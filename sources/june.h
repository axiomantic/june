/**
 * June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
 *
 * Licensed and distributed under the
 *   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
 *
 * This file may not be copied, modified, or distributed except according to those terms.
 */

#pragma once

#include <exception>
#include <functional>
#include <stdexcept>
#include <type_traits>

#include <juce_gui_basics/juce_gui_basics.h>

// JUCE Section ===================================================================================

#if JUCE_MAC
namespace juce { extern void initialiseNSApplication(); }
#endif

namespace june {

inline juce::JUCEApplicationBase* createJuceApplicationEmptyInstance() { return nullptr; }

inline void initialiseJune()
{
    juce::JUCEApplicationBase::createInstance = &createJuceApplicationEmptyInstance;

#if JUCE_MAC
    juce::initialiseNSApplication();
#endif
}

inline bool initialiseApplication(juce::JUCEApplication* application)
{
    return static_cast<juce::JUCEApplicationBase*>(application)->initialiseApp();
}

inline int shutdownApplication(juce::JUCEApplication* application)
{
    return static_cast<juce::JUCEApplicationBase*>(application)->shutdownApp();
}

// Utils Section ===================================================================================

namespace detail {

template <class, class...>
struct closure_traits;

template <class, class, class>
struct closure_traits_concat {};

template <class R, class Arg>
struct closure_traits<R, Arg>
{
    using type = std::function<R()>;

    template <class F, class E>
    static type map(F func, E env) noexcept(noexcept((*std::declval<F>())(std::declval<E>())))
    {
        if constexpr (std::is_void_v<R>)
            return [func, env] { (*func)(env); };
        else
            return [func, env] { return (*func)(env); };
    };
};

template <class R, class... Args1, class... Args2>
struct closure_traits_concat<R, std::function<R(Args1...)>, std::function<R(Args2...)>>
{
    using type = std::function<R(Args1..., Args2...)>;

    template <class F, class E>
    static type map(F func, E env) noexcept(noexcept((*std::declval<F>())(std::declval<Args1>()..., std::declval<Args2>()..., std::declval<E>())))
    {
        if constexpr (std::is_void_v<R>)
            return [func, env](Args1... args1, Args2... args2) { (*func)(args1..., args2..., env); };
        else
            return [func, env](Args1... args1, Args2... args2) { return (*func)(args1..., args2..., env); };
    };
};

template <class R, class Arg, class... Args>
struct closure_traits<R, Arg, Args...>
{
    using type = typename closure_traits_concat<R,
        std::function<R(Arg)>, typename closure_traits<R, Args...>::type>::type;

    template <class F, class E>
    static type map(F func, E env) noexcept(noexcept(closure_traits_concat<R,
            std::function<R(Arg)>, typename closure_traits<R, Args...>::type>::map(std::declval<F>(), std::declval<E>())))
    {
        return closure_traits_concat<R,
            std::function<R(Arg)>, typename closure_traits<R, Args...>::type>::map(func, env);
    };
};

template <class R, class... Args>
struct function_traits_base
{
    template <class F, class E>
    static auto map(F func, E env) noexcept(noexcept(closure_traits<R, Args...>::map(std::declval<F>(), std::declval<E>())))
    {
        return closure_traits<R, Args...>::map(func, env);
    };
};

template <class...>
struct function_traits_impl;

template <class R, class... Args>
struct function_traits_impl<R(Args...)> : function_traits_base<R, Args...> {};

template <class R, class... Args>
struct function_traits_impl<R (*)(Args...)> : function_traits_base<R, Args...> {};

template <class C, class R, class... Args>
struct function_traits_impl<R (C::*)(Args...)> : function_traits_base<R, Args...> {};

template <class C, class R, class... Args>
struct function_traits_impl<R (C::*)(Args...) const> : function_traits_base<R, Args...> {};

template <class R, class... Args>
struct function_traits_impl<R(Args...) noexcept> : function_traits_base<R, Args...> {};

template <class R, class... Args>
struct function_traits_impl<R (*)(Args...) noexcept> : function_traits_base<R, Args...> {};

template <class C, class R, class... Args>
struct function_traits_impl<R (C::*)(Args...) noexcept> : function_traits_base<R, Args...> {};

} // namespace detail

template <class F>
struct function_traits : detail::function_traits_impl<F> {};

/**
 * What a generated override returns when no handler has been set.
 *
 * The forwarder used to `return {}`, which does not compile for a type with no
 * default constructor - juce::Justification and juce::Font are both that - so a
 * look and feel method returning one could not be generated at all. This gives
 * every type an answer: the value-initialised one where that exists, and a loud
 * failure otherwise, which is the only honest thing to return when nothing was
 * ever set.
 */
template <class R>
R fallback()
{
    if constexpr (std::is_default_constructible_v<R>)
        return R{};
    else
        throw std::logic_error ("june: a virtual was called with no handler set, "
                                "and its return type cannot be default constructed");
}

template <class F>
auto bind(F func, void* env) noexcept(noexcept(function_traits<F>::map(std::declval<F>(), std::declval<void*>())))
{
    return function_traits<F>::map(func, env);
}

/**
 * Builds a std::function whose result is a scalar-backed enum, from a Nim
 * closure that returns the base scalar.
 *
 * Every bound JUCE enum is a `distinct cint` on the Nim side, and Nim renders
 * one closure struct for `proc(): cint` and `proc(): SomeEnum`, typing its
 * function-pointer field from whichever it emits first. A program holding both
 * kinds then assigns a function pointer of the wrong type. So the Nim closure
 * returns the base scalar and never names the distinct, and the cast happens
 * here, on the value rather than on the function pointer.
 */
template <class Fn>
struct function_result;

template <class R, class... Args>
struct function_result<std::function<R(Args...)>>
{
    using type = R;
};

template <class Fn>
Fn bindCastingR0(int (*func)(void*), void* env)
{
    using R = typename function_result<Fn>::type;
    return [func, env]() -> R { return static_cast<R>(func(env)); };
}

/**
 * Builds a std::function whose argument is a const reference.
 *
 * bind() deduces the std::function from the Nim proc's own arguments, so a Nim
 * proc taking `ptr T` produces std::function<R(T*)>. That does not convert to
 * the std::function<R(const T&)> JUCE asks for, and for a type that holds a
 * reference member - var::NativeFunctionArgs - the by-value form does not
 * compile at all.
 *
 * Nim has no const pointer, so the callback receives a mutable one.
 */
template <class R, class T>
std::function<R(const T&)> bindConstRef(R (*func)(T*, void*), void* env)
{
    return [func, env](const T& arg) -> R { return func(const_cast<T*>(&arg), env); };
}

} // namespace june
