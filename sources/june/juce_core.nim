import june_common

const juce_core = "../../JUCE/modules/juce_core/juce_core.h"

type
  OrderedContainerHelpers* {.header: juce_core, importcpp: "juce::OrderedContainerHelpers", inheritable, pure.} = object
  ScopedAutoReleasePool* {.header: juce_core, importcpp: "juce::ScopedAutoReleasePool", inheritable, pure.} = object
  ByteOrder* {.header: juce_core, importcpp: "juce::ByteOrder", inheritable, pure.} = object
  CharacterFunctions* {.header: juce_core, importcpp: "juce::CharacterFunctions", inheritable, pure.} = object
  CharPointer_UTF8* {.header: juce_core, importcpp: "juce::CharPointer_UTF8", inheritable, pure.} = object
  CharPointer_UTF16* {.header: juce_core, importcpp: "juce::CharPointer_UTF16", inheritable, pure.} = object
  CharPointer_UTF32* {.header: juce_core, importcpp: "juce::CharPointer_UTF32", inheritable, pure.} = object
  CharPointer_ASCII* {.header: juce_core, importcpp: "juce::CharPointer_ASCII", inheritable, pure.} = object
  String* {.header: juce_core, importcpp: "juce::String", inheritable, pure.} = object
  StringRef* {.header: juce_core, importcpp: "juce::StringRef", inheritable, pure.} = object
  Logger* {.header: juce_core, importcpp: "juce::Logger", inheritable, pure.} = object
  MemoryBlock* {.header: juce_core, importcpp: "juce::MemoryBlock", inheritable, pure.} = object
  ReferenceCountedObject* {.header: juce_core, importcpp: "juce::ReferenceCountedObject", inheritable, pure.} = object
  SingleThreadedReferenceCountedObject* {.header: juce_core, importcpp: "juce::SingleThreadedReferenceCountedObject", inheritable, pure.} = object
  CriticalSection* {.header: juce_core, importcpp: "juce::CriticalSection", inheritable, pure.} = object
  DummyCriticalSection* {.header: juce_core, importcpp: "juce::DummyCriticalSection", inheritable, pure.} = object
  DummyCriticalSectionScopedLockType* {.header: juce_core, importcpp: "juce::DummyCriticalSection::ScopedLockType", inheritable, pure.} = object
  NullCheckedInvocation* {.header: juce_core, importcpp: "juce::NullCheckedInvocation", inheritable, pure.} = object
  ErasedScopeGuard* {.header: juce_core, importcpp: "juce::ErasedScopeGuard", inheritable, pure.} = object
  AbstractFifo* {.header: juce_core, importcpp: "juce::AbstractFifo", inheritable, pure.} = object
  SingleThreadedAbstractFifo* {.header: juce_core, importcpp: "juce::SingleThreadedAbstractFifo", inheritable, pure.} = object
  NewLine* {.header: juce_core, importcpp: "juce::NewLine", inheritable, pure.} = object
  StringPool* {.header: juce_core, importcpp: "juce::StringPool", inheritable, pure.} = object
  Identifier* {.header: juce_core, importcpp: "juce::Identifier", inheritable, pure.} = object
  StringArray* {.header: juce_core, importcpp: "juce::StringArray", inheritable, pure.} = object
  SystemStats* {.header: juce_core, importcpp: "juce::SystemStats", inheritable, pure.} = object
  StringPairArray* {.header: juce_core, importcpp: "juce::StringPairArray", inheritable, pure.} = object
  TextDiff* {.header: juce_core, importcpp: "juce::TextDiff", inheritable, pure.} = object
  TextDiffChange* {.header: juce_core, importcpp: "juce::TextDiff::Change", inheritable, pure.} = object
  LocalisedStrings* {.header: juce_core, importcpp: "juce::LocalisedStrings", inheritable, pure.} = object
  Base64* {.header: juce_core, importcpp: "juce::Base64", inheritable, pure.} = object
  Result* {.header: juce_core, importcpp: "juce::Result", inheritable, pure.} = object
  Uuid* {.header: juce_core, importcpp: "juce::Uuid", inheritable, pure.} = object
  ArgumentList* {.header: juce_core, importcpp: "juce::ArgumentList", inheritable, pure.} = object
  ArgumentListArgument* {.header: juce_core, importcpp: "juce::ArgumentList::Argument", inheritable, pure.} = object
  ConsoleApplication* {.header: juce_core, importcpp: "juce::ConsoleApplication", inheritable, pure.} = object
  ConsoleApplicationCommand* {.header: juce_core, importcpp: "juce::ConsoleApplication::Command", inheritable, pure.} = object
  juce_var* {.header: juce_core, importcpp: "juce::var", inheritable, pure.} = object
  juce_varNativeFunctionArgs* {.header: juce_core, importcpp: "juce::var::NativeFunctionArgs", inheritable, pure.} = object
  NamedValue* {.header: juce_core, importcpp: "juce::NamedValue", inheritable, pure.} = object
  NamedValueSet* {.header: juce_core, importcpp: "juce::NamedValueSet", inheritable, pure.} = object
  JSON* {.header: juce_core, importcpp: "juce::JSON", inheritable, pure.} = object
  JSONFormatOptions* {.header: juce_core, importcpp: "juce::JSON::FormatOptions", inheritable, pure.} = object
  DynamicObject* {.header: juce_core, importcpp: "juce::DynamicObject", inheritable, pure.} = object of ReferenceCountedObject
  DefaultHashFunctions* {.header: juce_core, importcpp: "juce::DefaultHashFunctions", inheritable, pure.} = object
  RelativeTime* {.header: juce_core, importcpp: "juce::RelativeTime", inheritable, pure.} = object
  Time* {.header: juce_core, importcpp: "juce::Time", inheritable, pure.} = object
  InputStream* {.header: juce_core, importcpp: "juce::InputStream", inheritable, pure.} = object
  OutputStream* {.header: juce_core, importcpp: "juce::OutputStream", inheritable, pure.} = object
  BufferedInputStream* {.header: juce_core, importcpp: "juce::BufferedInputStream", inheritable, pure.} = object of InputStream
  MemoryInputStream* {.header: juce_core, importcpp: "juce::MemoryInputStream", inheritable, pure.} = object of InputStream
  MemoryOutputStream* {.header: juce_core, importcpp: "juce::MemoryOutputStream", inheritable, pure.} = object of OutputStream
  SubregionStream* {.header: juce_core, importcpp: "juce::SubregionStream", inheritable, pure.} = object of InputStream
  InputSource* {.header: juce_core, importcpp: "juce::InputSource", inheritable, pure.} = object
  File* {.header: juce_core, importcpp: "juce::File", inheritable, pure.} = object
  FileNaturalFileComparator* {.header: juce_core, importcpp: "juce::File::NaturalFileComparator", inheritable, pure.} = object
  DirectoryIterator* {.header: juce_core, importcpp: "juce::DirectoryIterator", inheritable, pure.} = object
  DirectoryEntry* {.header: juce_core, importcpp: "juce::DirectoryEntry", inheritable, pure.} = object
  RangedDirectoryIterator* {.header: juce_core, importcpp: "juce::RangedDirectoryIterator", inheritable, pure.} = object
  FileInputStream* {.header: juce_core, importcpp: "juce::FileInputStream", inheritable, pure.} = object of InputStream
  FileOutputStream* {.header: juce_core, importcpp: "juce::FileOutputStream", inheritable, pure.} = object of OutputStream
  FileSearchPath* {.header: juce_core, importcpp: "juce::FileSearchPath", inheritable, pure.} = object
  MemoryMappedFile* {.header: juce_core, importcpp: "juce::MemoryMappedFile", inheritable, pure.} = object
  TemporaryFile* {.header: juce_core, importcpp: "juce::TemporaryFile", inheritable, pure.} = object
  FileFilter* {.header: juce_core, importcpp: "juce::FileFilter", inheritable, pure.} = object
  WildcardFileFilter* {.header: juce_core, importcpp: "juce::WildcardFileFilter", inheritable, pure.} = object of FileFilter
  FileInputSource* {.header: juce_core, importcpp: "juce::FileInputSource", inheritable, pure.} = object of InputSource
  FileLogger* {.header: juce_core, importcpp: "juce::FileLogger", inheritable, pure.} = object of Logger
  JSONUtils* {.header: juce_core, importcpp: "juce::JSONUtils", inheritable, pure.} = object
  SerialisationTraits* {.header: juce_core, importcpp: "juce::SerialisationTraits", inheritable, pure.} = object
  ToVarOptions* {.header: juce_core, importcpp: "juce::ToVarOptions", inheritable, pure.} = object
  ToVar* {.header: juce_core, importcpp: "juce::ToVar", inheritable, pure.} = object
  FromVar* {.header: juce_core, importcpp: "juce::FromVar", inheritable, pure.} = object
  VariantConverter* {.header: juce_core, importcpp: "juce::VariantConverter", inheritable, pure.} = object
  BigInteger* {.header: juce_core, importcpp: "juce::BigInteger", inheritable, pure.} = object
  Expression* {.header: juce_core, importcpp: "juce::Expression", inheritable, pure.} = object
  ExpressionScope* {.header: juce_core, importcpp: "juce::Expression::Scope", inheritable, pure.} = object
  ExpressionSymbol* {.header: juce_core, importcpp: "juce::Expression::Symbol", inheritable, pure.} = object
  Random* {.header: juce_core, importcpp: "juce::Random", inheritable, pure.} = object
  RuntimePermissions* {.header: juce_core, importcpp: "juce::RuntimePermissions", inheritable, pure.} = object
  ChildProcess* {.header: juce_core, importcpp: "juce::ChildProcess", inheritable, pure.} = object
  DynamicLibrary* {.header: juce_core, importcpp: "juce::DynamicLibrary", inheritable, pure.} = object
  InterProcessLock* {.header: juce_core, importcpp: "juce::InterProcessLock", inheritable, pure.} = object
  InterProcessLockScopedLockType* {.header: juce_core, importcpp: "juce::InterProcessLock::ScopedLockType", inheritable, pure.} = object
  Process* {.header: juce_core, importcpp: "juce::Process", inheritable, pure.} = object
  SpinLock* {.header: juce_core, importcpp: "juce::SpinLock", inheritable, pure.} = object
  WaitableEvent* {.header: juce_core, importcpp: "juce::WaitableEvent", inheritable, pure.} = object
  Thread* {.header: juce_core, importcpp: "juce::Thread", inheritable, pure.} = object
  ThreadRealtimeOptions* {.header: juce_core, importcpp: "juce::Thread::RealtimeOptions", inheritable, pure.} = object
  ThreadListener* {.header: juce_core, importcpp: "juce::Thread::Listener", inheritable, pure.} = object
  HighResolutionTimer* {.header: juce_core, importcpp: "juce::HighResolutionTimer", inheritable, pure.} = object
  ThreadPoolJob* {.header: juce_core, importcpp: "juce::ThreadPoolJob", inheritable, pure.} = object
  ThreadPoolOptions* {.header: juce_core, importcpp: "juce::ThreadPoolOptions", inheritable, pure.} = object
  ThreadPool* {.header: juce_core, importcpp: "juce::ThreadPool", inheritable, pure.} = object
  ThreadPoolJobSelector* {.header: juce_core, importcpp: "juce::ThreadPool::JobSelector", inheritable, pure.} = object
  TimeSliceClient* {.header: juce_core, importcpp: "juce::TimeSliceClient", inheritable, pure.} = object
  TimeSliceThread* {.header: juce_core, importcpp: "juce::TimeSliceThread", inheritable, pure.} = object of Thread
  ReadWriteLock* {.header: juce_core, importcpp: "juce::ReadWriteLock", inheritable, pure.} = object
  ScopedReadLock* {.header: juce_core, importcpp: "juce::ScopedReadLock", inheritable, pure.} = object
  ScopedTryReadLock* {.header: juce_core, importcpp: "juce::ScopedTryReadLock", inheritable, pure.} = object
  ScopedWriteLock* {.header: juce_core, importcpp: "juce::ScopedWriteLock", inheritable, pure.} = object
  ScopedTryWriteLock* {.header: juce_core, importcpp: "juce::ScopedTryWriteLock", inheritable, pure.} = object
  IPAddress* {.header: juce_core, importcpp: "juce::IPAddress", inheritable, pure.} = object
  MACAddress* {.header: juce_core, importcpp: "juce::MACAddress", inheritable, pure.} = object
  NamedPipe* {.header: juce_core, importcpp: "juce::NamedPipe", inheritable, pure.} = object
  SocketOptions* {.header: juce_core, importcpp: "juce::SocketOptions", inheritable, pure.} = object
  StreamingSocket* {.header: juce_core, importcpp: "juce::StreamingSocket", inheritable, pure.} = object
  DatagramSocket* {.header: juce_core, importcpp: "juce::DatagramSocket", inheritable, pure.} = object
  URL* {.header: juce_core, importcpp: "juce::URL", inheritable, pure.} = object
  URLInputStreamOptions* {.header: juce_core, importcpp: "juce::URL::InputStreamOptions", inheritable, pure.} = object
  URLDownloadTask* {.header: juce_core, importcpp: "juce::URL::DownloadTask", inheritable, pure.} = object
  URLDownloadTaskListener* {.header: juce_core, importcpp: "juce::URL::DownloadTaskListener", inheritable, pure.} = object
  URLDownloadTaskOptions* {.header: juce_core, importcpp: "juce::URL::DownloadTaskOptions", inheritable, pure.} = object
  WebInputStream* {.header: juce_core, importcpp: "juce::WebInputStream", inheritable, pure.} = object of InputStream
  WebInputStreamListener* {.header: juce_core, importcpp: "juce::WebInputStream::Listener", inheritable, pure.} = object
  URLInputSource* {.header: juce_core, importcpp: "juce::URLInputSource", inheritable, pure.} = object of InputSource
  PerformanceCounter* {.header: juce_core, importcpp: "juce::PerformanceCounter", inheritable, pure.} = object
  PerformanceCounterStatistics* {.header: juce_core, importcpp: "juce::PerformanceCounter::Statistics", inheritable, pure.} = object
  ScopedTimeMeasurement* {.header: juce_core, importcpp: "juce::ScopedTimeMeasurement", inheritable, pure.} = object
  TimedDiagnostic* {.header: juce_core, importcpp: "juce::TimedDiagnostic", inheritable, pure.} = object
  UnitTest* {.header: juce_core, importcpp: "juce::UnitTest", inheritable, pure.} = object
  UnitTestRunner* {.header: juce_core, importcpp: "juce::UnitTestRunner", inheritable, pure.} = object
  UnitTestRunnerTestResult* {.header: juce_core, importcpp: "juce::UnitTestRunner::TestResult", inheritable, pure.} = object
  XmlDocument* {.header: juce_core, importcpp: "juce::XmlDocument", inheritable, pure.} = object
  XmlAttribute* {.header: juce_core, importcpp: "juce::XmlAttribute", inheritable, pure.} = object
  XmlElement* {.header: juce_core, importcpp: "juce::XmlElement", inheritable, pure.} = object
  XmlElementTextFormat* {.header: juce_core, importcpp: "juce::XmlElement::TextFormat", inheritable, pure.} = object
  GZIPCompressorOutputStream* {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream", inheritable, pure.} = object of OutputStream
  GZIPDecompressorInputStream* {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream", inheritable, pure.} = object of InputStream
  ZipFile* {.header: juce_core, importcpp: "juce::ZipFile", inheritable, pure.} = object
  ZipFileZipEntry* {.header: juce_core, importcpp: "juce::ZipFile::ZipEntry", inheritable, pure.} = object
  ZipFileBuilder* {.header: juce_core, importcpp: "juce::ZipFile::Builder", inheritable, pure.} = object
  PropertySet* {.header: juce_core, importcpp: "juce::PropertySet", inheritable, pure.} = object
  Reservoir* {.header: juce_core, importcpp: "juce::Reservoir", inheritable, pure.} = object
  AndroidDocumentInfo* {.header: juce_core, importcpp: "juce::AndroidDocumentInfo", inheritable, pure.} = object
  AndroidDocumentInfoArgs* {.header: juce_core, importcpp: "juce::AndroidDocumentInfo::Args", inheritable, pure.} = object
  AndroidDocumentPermission* {.header: juce_core, importcpp: "juce::AndroidDocumentPermission", inheritable, pure.} = object
  AndroidDocument* {.header: juce_core, importcpp: "juce::AndroidDocument", inheritable, pure.} = object
  AndroidDocumentNativeInfo* {.header: juce_core, importcpp: "juce::AndroidDocument::NativeInfo", inheritable, pure.} = object
  AndroidDocumentIterator* {.header: juce_core, importcpp: "juce::AndroidDocumentIterator", inheritable, pure.} = object
  AndroidDocumentInputSource* {.header: juce_core, importcpp: "juce::AndroidDocumentInputSource", inheritable, pure.} = object of InputSource
  IncrementRef* {.header: juce_core, importcpp: "juce::IncrementRef".} = distinct cint
  SystemStatsOperatingSystemType* {.header: juce_core, importcpp: "juce::SystemStats::OperatingSystemType".} = distinct cint
  SystemStatsMachineIdFlags* {.header: juce_core, importcpp: "juce::SystemStats::MachineIdFlags".} = distinct cint
  JSONSpacing* {.header: juce_core, importcpp: "juce::JSON::Spacing".} = distinct cint
  JSONEncoding* {.header: juce_core, importcpp: "juce::JSON::Encoding".} = distinct cint
  FileTypesOfFileToFind* {.header: juce_core, importcpp: "juce::File::TypesOfFileToFind".} = distinct cint
  FileFollowSymlinks* {.header: juce_core, importcpp: "juce::File::FollowSymlinks".} = distinct cint
  FileSpecialLocationType* {.header: juce_core, importcpp: "juce::File::SpecialLocationType".} = distinct cint
  MemoryMappedFileAccessMode* {.header: juce_core, importcpp: "juce::MemoryMappedFile::AccessMode".} = distinct cint
  TemporaryFileOptionFlags* {.header: juce_core, importcpp: "juce::TemporaryFile::OptionFlags".} = distinct cint
  ExpressionType* {.header: juce_core, importcpp: "juce::Expression::Type".} = distinct cint
  RuntimePermissionsPermissionID* {.header: juce_core, importcpp: "juce::RuntimePermissions::PermissionID".} = distinct cint
  ChildProcessStreamFlags* {.header: juce_core, importcpp: "juce::ChildProcess::StreamFlags".} = distinct cint
  ProcessProcessPriority* {.header: juce_core, importcpp: "juce::Process::ProcessPriority".} = distinct cint
  ThreadPriority* {.header: juce_core, importcpp: "juce::Thread::Priority".} = distinct cint
  ThreadPoolJobJobStatus* {.header: juce_core, importcpp: "juce::ThreadPoolJob::JobStatus".} = distinct cint
  URLParameterHandling* {.header: juce_core, importcpp: "juce::URL::ParameterHandling".} = distinct cint
  GZIPCompressorOutputStreamWindowBitsValues* {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream::WindowBitsValues".} = distinct cint
  GZIPDecompressorInputStreamFormat* {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream::Format".} = distinct cint
  ZipFileOverwriteFiles* {.header: juce_core, importcpp: "juce::ZipFile::OverwriteFiles".} = distinct cint
  ZipFileFollowSymlinks* {.header: juce_core, importcpp: "juce::ZipFile::FollowSymlinks".} = distinct cint

let IncrementRef_no* {.header: juce_core, importcpp: "juce::IncrementRef::no".}: IncrementRef
let IncrementRef_yes* {.header: juce_core, importcpp: "juce::IncrementRef::yes".}: IncrementRef

let SystemStatsOperatingSystemType_UnknownOS* {.header: juce_core, importcpp: "juce::SystemStats::UnknownOS".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows* {.header: juce_core, importcpp: "juce::SystemStats::Windows".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Linux* {.header: juce_core, importcpp: "juce::SystemStats::Linux".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Android* {.header: juce_core, importcpp: "juce::SystemStats::Android".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_iOS* {.header: juce_core, importcpp: "juce::SystemStats::iOS".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_WASM* {.header: juce_core, importcpp: "juce::SystemStats::WASM".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_7* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_7".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_8* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_8".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_9* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_9".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_10* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_10".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_11* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_11".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_12* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_12".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_13* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_13".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_14* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_14".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOSX_10_15* {.header: juce_core, importcpp: "juce::SystemStats::MacOSX_10_15".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_11* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_11".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_12* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_12".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_13* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_13".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_14* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_14".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_15* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_15".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_MacOS_26* {.header: juce_core, importcpp: "juce::SystemStats::MacOS_26".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Win2000* {.header: juce_core, importcpp: "juce::SystemStats::Win2000".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_WinXP* {.header: juce_core, importcpp: "juce::SystemStats::WinXP".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_WinVista* {.header: juce_core, importcpp: "juce::SystemStats::WinVista".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows7* {.header: juce_core, importcpp: "juce::SystemStats::Windows7".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows8_0* {.header: juce_core, importcpp: "juce::SystemStats::Windows8_0".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows8_1* {.header: juce_core, importcpp: "juce::SystemStats::Windows8_1".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows10* {.header: juce_core, importcpp: "juce::SystemStats::Windows10".}: SystemStatsOperatingSystemType
let SystemStatsOperatingSystemType_Windows11* {.header: juce_core, importcpp: "juce::SystemStats::Windows11".}: SystemStatsOperatingSystemType

let SystemStatsMachineIdFlags_macAddresses* {.header: juce_core, importcpp: "juce::SystemStats::MachineIdFlags::macAddresses".}: SystemStatsMachineIdFlags
let SystemStatsMachineIdFlags_fileSystemId* {.header: juce_core, importcpp: "juce::SystemStats::MachineIdFlags::fileSystemId".}: SystemStatsMachineIdFlags
let SystemStatsMachineIdFlags_legacyUniqueId* {.header: juce_core, importcpp: "juce::SystemStats::MachineIdFlags::legacyUniqueId".}: SystemStatsMachineIdFlags
let SystemStatsMachineIdFlags_uniqueId* {.header: juce_core, importcpp: "juce::SystemStats::MachineIdFlags::uniqueId".}: SystemStatsMachineIdFlags

let JSONSpacing_none* {.header: juce_core, importcpp: "juce::JSON::Spacing::none".}: JSONSpacing
let JSONSpacing_singleLine* {.header: juce_core, importcpp: "juce::JSON::Spacing::singleLine".}: JSONSpacing
let JSONSpacing_multiLine* {.header: juce_core, importcpp: "juce::JSON::Spacing::multiLine".}: JSONSpacing

let JSONEncoding_utf8* {.header: juce_core, importcpp: "juce::JSON::Encoding::utf8".}: JSONEncoding
let JSONEncoding_ascii* {.header: juce_core, importcpp: "juce::JSON::Encoding::ascii".}: JSONEncoding

let FileTypesOfFileToFind_findDirectories* {.header: juce_core, importcpp: "juce::File::findDirectories".}: FileTypesOfFileToFind
let FileTypesOfFileToFind_findFiles* {.header: juce_core, importcpp: "juce::File::findFiles".}: FileTypesOfFileToFind
let FileTypesOfFileToFind_findFilesAndDirectories* {.header: juce_core, importcpp: "juce::File::findFilesAndDirectories".}: FileTypesOfFileToFind
let FileTypesOfFileToFind_ignoreHiddenFiles* {.header: juce_core, importcpp: "juce::File::ignoreHiddenFiles".}: FileTypesOfFileToFind

let FileFollowSymlinks_no* {.header: juce_core, importcpp: "juce::File::FollowSymlinks::no".}: FileFollowSymlinks
let FileFollowSymlinks_noCycles* {.header: juce_core, importcpp: "juce::File::FollowSymlinks::noCycles".}: FileFollowSymlinks
let FileFollowSymlinks_yes* {.header: juce_core, importcpp: "juce::File::FollowSymlinks::yes".}: FileFollowSymlinks

let FileSpecialLocationType_userHomeDirectory* {.header: juce_core, importcpp: "juce::File::userHomeDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userDocumentsDirectory* {.header: juce_core, importcpp: "juce::File::userDocumentsDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userDesktopDirectory* {.header: juce_core, importcpp: "juce::File::userDesktopDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userMusicDirectory* {.header: juce_core, importcpp: "juce::File::userMusicDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userMoviesDirectory* {.header: juce_core, importcpp: "juce::File::userMoviesDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userPicturesDirectory* {.header: juce_core, importcpp: "juce::File::userPicturesDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_userApplicationDataDirectory* {.header: juce_core, importcpp: "juce::File::userApplicationDataDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_commonApplicationDataDirectory* {.header: juce_core, importcpp: "juce::File::commonApplicationDataDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_commonDocumentsDirectory* {.header: juce_core, importcpp: "juce::File::commonDocumentsDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_tempDirectory* {.header: juce_core, importcpp: "juce::File::tempDirectory".}: FileSpecialLocationType
let FileSpecialLocationType_currentExecutableFile* {.header: juce_core, importcpp: "juce::File::currentExecutableFile".}: FileSpecialLocationType
let FileSpecialLocationType_currentApplicationFile* {.header: juce_core, importcpp: "juce::File::currentApplicationFile".}: FileSpecialLocationType
let FileSpecialLocationType_invokedExecutableFile* {.header: juce_core, importcpp: "juce::File::invokedExecutableFile".}: FileSpecialLocationType
let FileSpecialLocationType_hostApplicationPath* {.header: juce_core, importcpp: "juce::File::hostApplicationPath".}: FileSpecialLocationType
let FileSpecialLocationType_globalApplicationsDirectory* {.header: juce_core, importcpp: "juce::File::globalApplicationsDirectory".}: FileSpecialLocationType

let MemoryMappedFileAccessMode_readOnly* {.header: juce_core, importcpp: "juce::MemoryMappedFile::readOnly".}: MemoryMappedFileAccessMode
let MemoryMappedFileAccessMode_readWrite* {.header: juce_core, importcpp: "juce::MemoryMappedFile::readWrite".}: MemoryMappedFileAccessMode

let TemporaryFileOptionFlags_useHiddenFile* {.header: juce_core, importcpp: "juce::TemporaryFile::useHiddenFile".}: TemporaryFileOptionFlags
let TemporaryFileOptionFlags_putNumbersInBrackets* {.header: juce_core, importcpp: "juce::TemporaryFile::putNumbersInBrackets".}: TemporaryFileOptionFlags

let ExpressionType_constantType* {.header: juce_core, importcpp: "juce::Expression::constantType".}: ExpressionType
let ExpressionType_functionType* {.header: juce_core, importcpp: "juce::Expression::functionType".}: ExpressionType
let ExpressionType_operatorType* {.header: juce_core, importcpp: "juce::Expression::operatorType".}: ExpressionType
let ExpressionType_symbolType* {.header: juce_core, importcpp: "juce::Expression::symbolType".}: ExpressionType

let RuntimePermissionsPermissionID_recordAudio* {.header: juce_core, importcpp: "juce::RuntimePermissions::recordAudio".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_bluetoothMidi* {.header: juce_core, importcpp: "juce::RuntimePermissions::bluetoothMidi".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_readExternalStorage* {.header: juce_core, importcpp: "juce::RuntimePermissions::readExternalStorage".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_writeExternalStorage* {.header: juce_core, importcpp: "juce::RuntimePermissions::writeExternalStorage".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_camera* {.header: juce_core, importcpp: "juce::RuntimePermissions::camera".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_readMediaAudio* {.header: juce_core, importcpp: "juce::RuntimePermissions::readMediaAudio".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_readMediaImages* {.header: juce_core, importcpp: "juce::RuntimePermissions::readMediaImages".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_readMediaVideo* {.header: juce_core, importcpp: "juce::RuntimePermissions::readMediaVideo".}: RuntimePermissionsPermissionID
let RuntimePermissionsPermissionID_postNotification* {.header: juce_core, importcpp: "juce::RuntimePermissions::postNotification".}: RuntimePermissionsPermissionID

let ChildProcessStreamFlags_wantStdOut* {.header: juce_core, importcpp: "juce::ChildProcess::wantStdOut".}: ChildProcessStreamFlags
let ChildProcessStreamFlags_wantStdErr* {.header: juce_core, importcpp: "juce::ChildProcess::wantStdErr".}: ChildProcessStreamFlags

let ProcessProcessPriority_LowPriority* {.header: juce_core, importcpp: "juce::Process::LowPriority".}: ProcessProcessPriority
let ProcessProcessPriority_NormalPriority* {.header: juce_core, importcpp: "juce::Process::NormalPriority".}: ProcessProcessPriority
let ProcessProcessPriority_HighPriority* {.header: juce_core, importcpp: "juce::Process::HighPriority".}: ProcessProcessPriority
let ProcessProcessPriority_RealtimePriority* {.header: juce_core, importcpp: "juce::Process::RealtimePriority".}: ProcessProcessPriority

let ThreadPriority_highest* {.header: juce_core, importcpp: "juce::Thread::Priority::highest".}: ThreadPriority
let ThreadPriority_high* {.header: juce_core, importcpp: "juce::Thread::Priority::high".}: ThreadPriority
let ThreadPriority_normal* {.header: juce_core, importcpp: "juce::Thread::Priority::normal".}: ThreadPriority
let ThreadPriority_low* {.header: juce_core, importcpp: "juce::Thread::Priority::low".}: ThreadPriority
let ThreadPriority_background* {.header: juce_core, importcpp: "juce::Thread::Priority::background".}: ThreadPriority

let ThreadPoolJobJobStatus_jobHasFinished* {.header: juce_core, importcpp: "juce::ThreadPoolJob::jobHasFinished".}: ThreadPoolJobJobStatus
let ThreadPoolJobJobStatus_jobNeedsRunningAgain* {.header: juce_core, importcpp: "juce::ThreadPoolJob::jobNeedsRunningAgain".}: ThreadPoolJobJobStatus

let URLParameterHandling_inAddress* {.header: juce_core, importcpp: "juce::URL::ParameterHandling::inAddress".}: URLParameterHandling
let URLParameterHandling_inPostData* {.header: juce_core, importcpp: "juce::URL::ParameterHandling::inPostData".}: URLParameterHandling

let GZIPCompressorOutputStreamWindowBitsValues_windowBitsRaw* {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream::windowBitsRaw".}: GZIPCompressorOutputStreamWindowBitsValues
let GZIPCompressorOutputStreamWindowBitsValues_windowBitsGZIP* {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream::windowBitsGZIP".}: GZIPCompressorOutputStreamWindowBitsValues

let GZIPDecompressorInputStreamFormat_zlibFormat* {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream::zlibFormat".}: GZIPDecompressorInputStreamFormat
let GZIPDecompressorInputStreamFormat_deflateFormat* {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream::deflateFormat".}: GZIPDecompressorInputStreamFormat
let GZIPDecompressorInputStreamFormat_gzipFormat* {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream::gzipFormat".}: GZIPDecompressorInputStreamFormat

let ZipFileOverwriteFiles_no* {.header: juce_core, importcpp: "juce::ZipFile::OverwriteFiles::no".}: ZipFileOverwriteFiles
let ZipFileOverwriteFiles_yes* {.header: juce_core, importcpp: "juce::ZipFile::OverwriteFiles::yes".}: ZipFileOverwriteFiles

let ZipFileFollowSymlinks_no* {.header: juce_core, importcpp: "juce::ZipFile::FollowSymlinks::no".}: ZipFileFollowSymlinks
let ZipFileFollowSymlinks_yes* {.header: juce_core, importcpp: "juce::ZipFile::FollowSymlinks::yes".}: ZipFileFollowSymlinks

const
  CharPointer_UTF8_byteOrderMark1*: cint = 239
  CharPointer_UTF8_byteOrderMark2*: cint = 187
  CharPointer_UTF8_byteOrderMark3*: cint = 191

const
  CharPointer_UTF16_byteOrderMarkBE1*: cint = 254
  CharPointer_UTF16_byteOrderMarkBE2*: cint = 255
  CharPointer_UTF16_byteOrderMarkLE1*: cint = 255
  CharPointer_UTF16_byteOrderMarkLE2*: cint = 254

proc makeOrderedContainerHelpers*(): OrderedContainerHelpers {.header: juce_core, importcpp: "juce::OrderedContainerHelpers(@)".}
proc `==`*(this: OrderedContainerHelpers, other: OrderedContainerHelpers): bool {.error: "juce::OrderedContainerHelpers defines no operator==; compare a property instead".}

proc makeScopedAutoReleasePool*(): ScopedAutoReleasePool {.header: juce_core, importcpp: "juce::ScopedAutoReleasePool(@)".}
proc `==`*(this: ScopedAutoReleasePool, other: ScopedAutoReleasePool): bool {.error: "juce::ScopedAutoReleasePool defines no operator==; compare a property instead".}

proc `==`*(this: ByteOrder, other: ByteOrder): bool {.error: "juce::ByteOrder defines no operator==; compare a property instead".}

proc `==`*(this: CharacterFunctions, other: CharacterFunctions): bool {.error: "juce::CharacterFunctions defines no operator==; compare a property instead".}

proc makeCharPointer_UTF8*(rawPointer: ptr char): CharPointer_UTF8 {.header: juce_core, importcpp: "juce::CharPointer_UTF8(@)".}
proc `CharPointer_UTF8=`*(this: var CharPointer_UTF8, other: CharPointer_UTF8): var CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `CharPointer_UTF8=`*(this: var CharPointer_UTF8, text: ptr char): var CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<=`*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
proc `<`*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>=*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
# proc operator>*(this: CharPointer_UTF8, other: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc getAddress*(this: CharPointer_UTF8): ptr char {.header: juce_core, importcpp: "#.getAddress()".}
proc isEmpty*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc `*`*(this: CharPointer_UTF8): uint16 {.header: juce_core, importcpp: "#.operator*()".}
proc `inc`*(this: var CharPointer_UTF8): var CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator++()".}
proc `dec`*(this: var CharPointer_UTF8): var CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator--()".}
proc getAndAdvance*(this: var CharPointer_UTF8): uint16 {.header: juce_core, importcpp: "#.getAndAdvance()".}
proc `inc`*(this: var CharPointer_UTF8, arg1: cint): CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator++(@)".}
proc `+=`*(this: var CharPointer_UTF8, numToSkip: cint) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var CharPointer_UTF8, numToSkip: cint) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `[]`*(this: CharPointer_UTF8, characterIndex: cint): uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc `+`*(this: CharPointer_UTF8, numToSkip: cint): CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: CharPointer_UTF8, numToSkip: cint): CharPointer_UTF8 {.header: juce_core, importcpp: "#.operator-(@)".}
proc length*(this: CharPointer_UTF8): uint64 {.header: juce_core, importcpp: "#.length()".}
proc lengthUpTo*(this: CharPointer_UTF8, maxCharsToCount: uint64): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc lengthUpTo*(this: CharPointer_UTF8, `end`: CharPointer_UTF8): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc sizeInBytes*(this: CharPointer_UTF8): uint64 {.header: juce_core, importcpp: "#.sizeInBytes()".}
proc findTerminatingNull*(this: CharPointer_UTF8): CharPointer_UTF8 {.header: juce_core, importcpp: "#.findTerminatingNull()".}
proc write*(this: var CharPointer_UTF8, charToWrite: uint16) {.header: juce_core, importcpp: "#.write(@)".}
proc writeNull*(this: CharPointer_UTF8) {.header: juce_core, importcpp: "#.writeNull()".}
proc writeAll*(this: var CharPointer_UTF8, src: CharPointer_UTF8) {.header: juce_core, importcpp: "#.writeAll(@)".}
proc compareIgnoreCase*(this: CharPointer_UTF8, other: CharPointer_UTF8): cint {.header: juce_core, importcpp: "#.compareIgnoreCase(@)".}
proc indexOf*(this: CharPointer_UTF8, charToFind: uint16): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOf*(this: CharPointer_UTF8, charToFind: uint16, ignoreCase: bool): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc isWhitespace*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isWhitespace()".}
proc isDigit*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isDigit()".}
proc isLetter*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isLetter()".}
proc isLetterOrDigit*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isLetterOrDigit()".}
proc isUpperCase*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isUpperCase()".}
proc isLowerCase*(this: CharPointer_UTF8): bool {.header: juce_core, importcpp: "#.isLowerCase()".}
proc toUpperCase*(this: CharPointer_UTF8): uint16 {.header: juce_core, importcpp: "#.toUpperCase()".}
proc toLowerCase*(this: CharPointer_UTF8): uint16 {.header: juce_core, importcpp: "#.toLowerCase()".}
proc getIntValue32*(this: CharPointer_UTF8): cint {.header: juce_core, importcpp: "#.getIntValue32()".}
proc getIntValue64*(this: CharPointer_UTF8): int64 {.header: juce_core, importcpp: "#.getIntValue64()".}
proc getDoubleValue*(this: CharPointer_UTF8): float64 {.header: juce_core, importcpp: "#.getDoubleValue()".}
proc findEndOfWhitespace*(this: CharPointer_UTF8): CharPointer_UTF8 {.header: juce_core, importcpp: "#.findEndOfWhitespace()".}
proc incrementToEndOfWhitespace*(this: var CharPointer_UTF8) {.header: juce_core, importcpp: "#.incrementToEndOfWhitespace()".}
proc atomicSwap*(this: var CharPointer_UTF8, newValue: CharPointer_UTF8): CharPointer_UTF8 {.header: juce_core, importcpp: "#.atomicSwap(@)".}

proc makeCharPointer_UTF16*(rawPointer: ptr int16): CharPointer_UTF16 {.header: juce_core, importcpp: "juce::CharPointer_UTF16(@)".}
proc `CharPointer_UTF16=`*(this: var CharPointer_UTF16, other: CharPointer_UTF16): var CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `CharPointer_UTF16=`*(this: var CharPointer_UTF16, text: ptr int16): var CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<=`*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
proc `<`*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>=*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
# proc operator>*(this: CharPointer_UTF16, other: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc getAddress*(this: CharPointer_UTF16): ptr int16 {.header: juce_core, importcpp: "#.getAddress()".}
proc isEmpty*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc `*`*(this: CharPointer_UTF16): uint16 {.header: juce_core, importcpp: "#.operator*()".}
proc `inc`*(this: var CharPointer_UTF16): var CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator++()".}
proc `dec`*(this: var CharPointer_UTF16): var CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator--()".}
proc getAndAdvance*(this: var CharPointer_UTF16): uint16 {.header: juce_core, importcpp: "#.getAndAdvance()".}
proc `inc`*(this: var CharPointer_UTF16, arg1: cint): CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator++(@)".}
proc `+=`*(this: var CharPointer_UTF16, numToSkip: cint) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var CharPointer_UTF16, numToSkip: cint) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `[]`*(this: CharPointer_UTF16, characterIndex: cint): uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc `+`*(this: CharPointer_UTF16, numToSkip: cint): CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: CharPointer_UTF16, numToSkip: cint): CharPointer_UTF16 {.header: juce_core, importcpp: "#.operator-(@)".}
proc write*(this: var CharPointer_UTF16, charToWrite: uint16) {.header: juce_core, importcpp: "#.write(@)".}
proc writeNull*(this: CharPointer_UTF16) {.header: juce_core, importcpp: "#.writeNull()".}
proc length*(this: CharPointer_UTF16): uint64 {.header: juce_core, importcpp: "#.length()".}
proc lengthUpTo*(this: CharPointer_UTF16, maxCharsToCount: uint64): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc lengthUpTo*(this: CharPointer_UTF16, `end`: CharPointer_UTF16): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc sizeInBytes*(this: CharPointer_UTF16): uint64 {.header: juce_core, importcpp: "#.sizeInBytes()".}
proc findTerminatingNull*(this: CharPointer_UTF16): CharPointer_UTF16 {.header: juce_core, importcpp: "#.findTerminatingNull()".}
proc writeAll*(this: var CharPointer_UTF16, src: CharPointer_UTF16) {.header: juce_core, importcpp: "#.writeAll(@)".}
proc indexOf*(this: CharPointer_UTF16, charToFind: uint16): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOf*(this: CharPointer_UTF16, charToFind: uint16, ignoreCase: bool): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc isWhitespace*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isWhitespace()".}
proc isDigit*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isDigit()".}
proc isLetter*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isLetter()".}
proc isLetterOrDigit*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isLetterOrDigit()".}
proc isUpperCase*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isUpperCase()".}
proc isLowerCase*(this: CharPointer_UTF16): bool {.header: juce_core, importcpp: "#.isLowerCase()".}
proc toUpperCase*(this: CharPointer_UTF16): uint16 {.header: juce_core, importcpp: "#.toUpperCase()".}
proc toLowerCase*(this: CharPointer_UTF16): uint16 {.header: juce_core, importcpp: "#.toLowerCase()".}
proc getIntValue32*(this: CharPointer_UTF16): cint {.header: juce_core, importcpp: "#.getIntValue32()".}
proc getIntValue64*(this: CharPointer_UTF16): int64 {.header: juce_core, importcpp: "#.getIntValue64()".}
proc getDoubleValue*(this: CharPointer_UTF16): float64 {.header: juce_core, importcpp: "#.getDoubleValue()".}
proc findEndOfWhitespace*(this: CharPointer_UTF16): CharPointer_UTF16 {.header: juce_core, importcpp: "#.findEndOfWhitespace()".}
proc incrementToEndOfWhitespace*(this: var CharPointer_UTF16) {.header: juce_core, importcpp: "#.incrementToEndOfWhitespace()".}
proc atomicSwap*(this: var CharPointer_UTF16, newValue: CharPointer_UTF16): CharPointer_UTF16 {.header: juce_core, importcpp: "#.atomicSwap(@)".}

proc makeCharPointer_UTF32*(rawPointer: ptr uint16): CharPointer_UTF32 {.header: juce_core, importcpp: "juce::CharPointer_UTF32(@)".}
proc `CharPointer_UTF32=`*(this: var CharPointer_UTF32, other: CharPointer_UTF32): var CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `CharPointer_UTF32=`*(this: var CharPointer_UTF32, text: ptr uint16): var CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<=`*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
proc `<`*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>=*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
# proc operator>*(this: CharPointer_UTF32, other: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc getAddress*(this: CharPointer_UTF32): ptr uint16 {.header: juce_core, importcpp: "#.getAddress()".}
proc isEmpty*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc `*`*(this: CharPointer_UTF32): uint16 {.header: juce_core, importcpp: "#.operator*()".}
proc `inc`*(this: var CharPointer_UTF32): var CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator++()".}
proc `dec`*(this: var CharPointer_UTF32): var CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator--()".}
proc getAndAdvance*(this: var CharPointer_UTF32): uint16 {.header: juce_core, importcpp: "#.getAndAdvance()".}
proc `inc`*(this: var CharPointer_UTF32, arg1: cint): CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator++(@)".}
proc `+=`*(this: var CharPointer_UTF32, numToSkip: cint) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var CharPointer_UTF32, numToSkip: cint) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `[]`*(this: CharPointer_UTF32, characterIndex: cint): var uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc `+`*(this: CharPointer_UTF32, numToSkip: cint): CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: CharPointer_UTF32, numToSkip: cint): CharPointer_UTF32 {.header: juce_core, importcpp: "#.operator-(@)".}
proc write*(this: var CharPointer_UTF32, charToWrite: uint16) {.header: juce_core, importcpp: "#.write(@)".}
proc replaceChar*(this: var CharPointer_UTF32, newChar: uint16) {.header: juce_core, importcpp: "#.replaceChar(@)".}
proc writeNull*(this: CharPointer_UTF32) {.header: juce_core, importcpp: "#.writeNull()".}
proc length*(this: CharPointer_UTF32): uint64 {.header: juce_core, importcpp: "#.length()".}
proc lengthUpTo*(this: CharPointer_UTF32, maxCharsToCount: uint64): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc lengthUpTo*(this: CharPointer_UTF32, `end`: CharPointer_UTF32): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc sizeInBytes*(this: CharPointer_UTF32): uint64 {.header: juce_core, importcpp: "#.sizeInBytes()".}
proc findTerminatingNull*(this: CharPointer_UTF32): CharPointer_UTF32 {.header: juce_core, importcpp: "#.findTerminatingNull()".}
proc writeAll*(this: var CharPointer_UTF32, src: CharPointer_UTF32) {.header: juce_core, importcpp: "#.writeAll(@)".}
proc compare*(this: CharPointer_UTF32, other: CharPointer_UTF32): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc indexOf*(this: CharPointer_UTF32, charToFind: uint16): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOf*(this: CharPointer_UTF32, charToFind: uint16, ignoreCase: bool): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc isWhitespace*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isWhitespace()".}
proc isDigit*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isDigit()".}
proc isLetter*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isLetter()".}
proc isLetterOrDigit*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isLetterOrDigit()".}
proc isUpperCase*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isUpperCase()".}
proc isLowerCase*(this: CharPointer_UTF32): bool {.header: juce_core, importcpp: "#.isLowerCase()".}
proc toUpperCase*(this: CharPointer_UTF32): uint16 {.header: juce_core, importcpp: "#.toUpperCase()".}
proc toLowerCase*(this: CharPointer_UTF32): uint16 {.header: juce_core, importcpp: "#.toLowerCase()".}
proc getIntValue32*(this: CharPointer_UTF32): cint {.header: juce_core, importcpp: "#.getIntValue32()".}
proc getIntValue64*(this: CharPointer_UTF32): int64 {.header: juce_core, importcpp: "#.getIntValue64()".}
proc getDoubleValue*(this: CharPointer_UTF32): float64 {.header: juce_core, importcpp: "#.getDoubleValue()".}
proc findEndOfWhitespace*(this: CharPointer_UTF32): CharPointer_UTF32 {.header: juce_core, importcpp: "#.findEndOfWhitespace()".}
proc incrementToEndOfWhitespace*(this: var CharPointer_UTF32) {.header: juce_core, importcpp: "#.incrementToEndOfWhitespace()".}
proc atomicSwap*(this: var CharPointer_UTF32, newValue: CharPointer_UTF32): CharPointer_UTF32 {.header: juce_core, importcpp: "#.atomicSwap(@)".}

proc makeCharPointer_ASCII*(rawPointer: ptr char): CharPointer_ASCII {.header: juce_core, importcpp: "juce::CharPointer_ASCII(@)".}
proc `CharPointer_ASCII=`*(this: var CharPointer_ASCII, other: CharPointer_ASCII): var CharPointer_ASCII {.header: juce_core, importcpp: "#.operator=(@)".}
proc `CharPointer_ASCII=`*(this: var CharPointer_ASCII, text: ptr char): var CharPointer_ASCII {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<=`*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
proc `<`*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>=*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
# proc operator>*(this: CharPointer_ASCII, other: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc getAddress*(this: CharPointer_ASCII): ptr char {.header: juce_core, importcpp: "#.getAddress()".}
proc isEmpty*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc `*`*(this: CharPointer_ASCII): uint16 {.header: juce_core, importcpp: "#.operator*()".}
proc `inc`*(this: var CharPointer_ASCII): var CharPointer_ASCII {.header: juce_core, importcpp: "#.operator++()".}
proc `dec`*(this: var CharPointer_ASCII): var CharPointer_ASCII {.header: juce_core, importcpp: "#.operator--()".}
proc getAndAdvance*(this: var CharPointer_ASCII): uint16 {.header: juce_core, importcpp: "#.getAndAdvance()".}
proc `inc`*(this: var CharPointer_ASCII, arg1: cint): CharPointer_ASCII {.header: juce_core, importcpp: "#.operator++(@)".}
proc `+=`*(this: var CharPointer_ASCII, numToSkip: cint) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var CharPointer_ASCII, numToSkip: cint) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `[]`*(this: CharPointer_ASCII, characterIndex: cint): uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc `+`*(this: CharPointer_ASCII, numToSkip: cint): CharPointer_ASCII {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: CharPointer_ASCII, numToSkip: cint): CharPointer_ASCII {.header: juce_core, importcpp: "#.operator-(@)".}
proc write*(this: var CharPointer_ASCII, charToWrite: uint16) {.header: juce_core, importcpp: "#.write(@)".}
proc replaceChar*(this: var CharPointer_ASCII, newChar: uint16) {.header: juce_core, importcpp: "#.replaceChar(@)".}
proc writeNull*(this: CharPointer_ASCII) {.header: juce_core, importcpp: "#.writeNull()".}
proc length*(this: CharPointer_ASCII): uint64 {.header: juce_core, importcpp: "#.length()".}
proc lengthUpTo*(this: CharPointer_ASCII, maxCharsToCount: uint64): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc lengthUpTo*(this: CharPointer_ASCII, `end`: CharPointer_ASCII): uint64 {.header: juce_core, importcpp: "#.lengthUpTo(@)".}
proc sizeInBytes*(this: CharPointer_ASCII): uint64 {.header: juce_core, importcpp: "#.sizeInBytes()".}
proc findTerminatingNull*(this: CharPointer_ASCII): CharPointer_ASCII {.header: juce_core, importcpp: "#.findTerminatingNull()".}
proc compare*(this: CharPointer_ASCII, other: CharPointer_ASCII): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc compareUpTo*(this: CharPointer_ASCII, other: CharPointer_ASCII, maxChars: cint): cint {.header: juce_core, importcpp: "#.compareUpTo(@)".}
proc compareIgnoreCase*(this: CharPointer_ASCII, other: CharPointer_ASCII): cint {.header: juce_core, importcpp: "#.compareIgnoreCase(@)".}
proc indexOf*(this: CharPointer_ASCII, charToFind: uint16): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOf*(this: CharPointer_ASCII, charToFind: uint16, ignoreCase: bool): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc isWhitespace*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isWhitespace()".}
proc isDigit*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isDigit()".}
proc isLetter*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isLetter()".}
proc isLetterOrDigit*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isLetterOrDigit()".}
proc isUpperCase*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isUpperCase()".}
proc isLowerCase*(this: CharPointer_ASCII): bool {.header: juce_core, importcpp: "#.isLowerCase()".}
proc toUpperCase*(this: CharPointer_ASCII): uint16 {.header: juce_core, importcpp: "#.toUpperCase()".}
proc toLowerCase*(this: CharPointer_ASCII): uint16 {.header: juce_core, importcpp: "#.toLowerCase()".}
proc getIntValue32*(this: CharPointer_ASCII): cint {.header: juce_core, importcpp: "#.getIntValue32()".}
proc getIntValue64*(this: CharPointer_ASCII): int64 {.header: juce_core, importcpp: "#.getIntValue64()".}
proc getDoubleValue*(this: CharPointer_ASCII): float64 {.header: juce_core, importcpp: "#.getDoubleValue()".}
proc findEndOfWhitespace*(this: CharPointer_ASCII): CharPointer_ASCII {.header: juce_core, importcpp: "#.findEndOfWhitespace()".}
proc incrementToEndOfWhitespace*(this: var CharPointer_ASCII) {.header: juce_core, importcpp: "#.incrementToEndOfWhitespace()".}

proc makeString*(): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: constChar): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: constChar, maxChars: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: ptr uint16): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: ptr uint16, maxChars: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF8): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF8, maxChars: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(start: CharPointer_UTF8, `end`: CharPointer_UTF8): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF16): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF16, maxChars: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(start: CharPointer_UTF16, `end`: CharPointer_UTF16): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF32): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_UTF32, maxChars: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(start: CharPointer_UTF32, `end`: CharPointer_UTF32): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(text: CharPointer_ASCII): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(arg1: CppString): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: cint): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: uint32): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: int16): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: uint16): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(largeIntegerValue: int64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(largeIntegerValue: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: int64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(decimalInteger: uint64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(floatValue: cfloat): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(doubleValue: float64): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(floatValue: cfloat, numberOfDecimalPlaces: cint, useScientificNotation: bool): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(doubleValue: float64, numberOfDecimalPlaces: cint, useScientificNotation: bool): String {.header: juce_core, importcpp: "juce::String(@)".}
proc makeString*(arg1: bool): String {.header: juce_core, importcpp: "juce::String(@)".}
proc hashCode*(this: String): cint {.header: juce_core, importcpp: "#.hashCode()".}
proc hashCode64*(this: String): int64 {.header: juce_core, importcpp: "#.hashCode64()".}
proc hash*(this: String): uint64 {.header: juce_core, importcpp: "#.hash()".}
proc length*(this: String): cint {.header: juce_core, importcpp: "#.length()".}
proc `String=`*(this: var String, other: String): var String {.header: juce_core, importcpp: "#.operator=(@)".}
proc `String=`*(this: var String, other: lent String): var String {.header: juce_core, importcpp: "#.operator=(@)".}
proc `+=`*(this: var String, stringToAppend: String) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, textToAppend: ptr uint16) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, numberToAppend: cint) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, numberToAppend: int64) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, numberToAppend: uint64) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, characterToAppend: char) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `+=`*(this: var String, characterToAppend: uint16) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc append*(this: var String, textToAppend: String, maxCharsToTake: uint64) {.header: juce_core, importcpp: "#.append(@)".}
proc appendCharPointer*(this: var String, startOfTextToAppend: CharPointer_UTF8, endOfTextToAppend: CharPointer_UTF8) {.header: juce_core, importcpp: "#.appendCharPointer(@)".}
proc appendCharPointer*(this: var String, textToAppend: CharPointer_UTF8) {.header: juce_core, importcpp: "#.appendCharPointer(@)".}
proc isEmpty*(this: String): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: String): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc clear*(this: var String) {.header: juce_core, importcpp: "#.clear()".}
proc equalsIgnoreCase*(this: String, other: String): bool {.header: juce_core, importcpp: "#.equalsIgnoreCase(@)".}
proc equalsIgnoreCase*(this: String, other: StringRef): bool {.header: juce_core, importcpp: "#.equalsIgnoreCase(@)".}
proc equalsIgnoreCase*(this: String, other: ptr uint16): bool {.header: juce_core, importcpp: "#.equalsIgnoreCase(@)".}
proc equalsIgnoreCase*(this: String, other: constChar): bool {.header: juce_core, importcpp: "#.equalsIgnoreCase(@)".}
proc compare*(this: String, other: String): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc compare*(this: String, other: constChar): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc compare*(this: String, other: ptr uint16): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc compareIgnoreCase*(this: String, other: String): cint {.header: juce_core, importcpp: "#.compareIgnoreCase(@)".}
proc compareNatural*(this: String, other: StringRef, isCaseSensitive: bool = false): cint {.header: juce_core, importcpp: "#.compareNatural(@)".}
proc startsWith*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.startsWith(@)".}
proc startsWithChar*(this: String, character: uint16): bool {.header: juce_core, importcpp: "#.startsWithChar(@)".}
proc startsWithIgnoreCase*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.startsWithIgnoreCase(@)".}
proc endsWith*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.endsWith(@)".}
proc endsWithChar*(this: String, character: uint16): bool {.header: juce_core, importcpp: "#.endsWithChar(@)".}
proc endsWithIgnoreCase*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.endsWithIgnoreCase(@)".}
proc contains*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.contains(@)".}
proc containsChar*(this: String, character: uint16): bool {.header: juce_core, importcpp: "#.containsChar(@)".}
proc containsIgnoreCase*(this: String, text: StringRef): bool {.header: juce_core, importcpp: "#.containsIgnoreCase(@)".}
proc containsWholeWord*(this: String, wordToLookFor: StringRef): bool {.header: juce_core, importcpp: "#.containsWholeWord(@)".}
proc containsWholeWordIgnoreCase*(this: String, wordToLookFor: StringRef): bool {.header: juce_core, importcpp: "#.containsWholeWordIgnoreCase(@)".}
proc indexOfWholeWord*(this: String, wordToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOfWholeWord(@)".}
proc indexOfWholeWordIgnoreCase*(this: String, wordToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOfWholeWordIgnoreCase(@)".}
proc containsAnyOf*(this: String, charactersItMightContain: StringRef): bool {.header: juce_core, importcpp: "#.containsAnyOf(@)".}
proc containsOnly*(this: String, charactersItMightContain: StringRef): bool {.header: juce_core, importcpp: "#.containsOnly(@)".}
proc containsNonWhitespaceChars*(this: String): bool {.header: juce_core, importcpp: "#.containsNonWhitespaceChars()".}
proc matchesWildcard*(this: String, wildcard: StringRef, ignoreCase: bool): bool {.header: juce_core, importcpp: "#.matchesWildcard(@)".}
proc indexOfChar*(this: String, characterToLookFor: uint16): cint {.header: juce_core, importcpp: "#.indexOfChar(@)".}
proc indexOfChar*(this: String, startIndex: cint, characterToLookFor: uint16): cint {.header: juce_core, importcpp: "#.indexOfChar(@)".}
proc indexOfAnyOf*(this: String, charactersToLookFor: StringRef, startIndex: cint = 0, ignoreCase: bool = false): cint {.header: juce_core, importcpp: "#.indexOfAnyOf(@)".}
proc indexOf*(this: String, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOf*(this: String, startIndex: cint, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc indexOfIgnoreCase*(this: String, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOfIgnoreCase(@)".}
proc indexOfIgnoreCase*(this: String, startIndex: cint, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.indexOfIgnoreCase(@)".}
proc lastIndexOfChar*(this: String, character: uint16): cint {.header: juce_core, importcpp: "#.lastIndexOfChar(@)".}
proc lastIndexOf*(this: String, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.lastIndexOf(@)".}
proc lastIndexOfIgnoreCase*(this: String, textToLookFor: StringRef): cint {.header: juce_core, importcpp: "#.lastIndexOfIgnoreCase(@)".}
proc lastIndexOfAnyOf*(this: String, charactersToLookFor: StringRef, ignoreCase: bool = false): cint {.header: juce_core, importcpp: "#.lastIndexOfAnyOf(@)".}
proc `[]`*(this: String, index: cint): uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc getLastCharacter*(this: String): uint16 {.header: juce_core, importcpp: "#.getLastCharacter()".}
proc substring*(this: String, startIndex: cint, endIndex: cint): String {.header: juce_core, importcpp: "#.substring(@)".}
proc substring*(this: String, startIndex: cint): String {.header: juce_core, importcpp: "#.substring(@)".}
proc dropLastCharacters*(this: String, numberToDrop: cint): String {.header: juce_core, importcpp: "#.dropLastCharacters(@)".}
proc getLastCharacters*(this: String, numCharacters: cint): String {.header: juce_core, importcpp: "#.getLastCharacters(@)".}
proc fromFirstOccurrenceOf*(this: String, substringToStartFrom: StringRef, includeSubStringInResult: bool, ignoreCase: bool): String {.header: juce_core, importcpp: "#.fromFirstOccurrenceOf(@)".}
proc fromLastOccurrenceOf*(this: String, substringToFind: StringRef, includeSubStringInResult: bool, ignoreCase: bool): String {.header: juce_core, importcpp: "#.fromLastOccurrenceOf(@)".}
proc upToFirstOccurrenceOf*(this: String, substringToEndWith: StringRef, includeSubStringInResult: bool, ignoreCase: bool): String {.header: juce_core, importcpp: "#.upToFirstOccurrenceOf(@)".}
proc upToLastOccurrenceOf*(this: String, substringToFind: StringRef, includeSubStringInResult: bool, ignoreCase: bool): String {.header: juce_core, importcpp: "#.upToLastOccurrenceOf(@)".}
proc trim*(this: String): String {.header: juce_core, importcpp: "#.trim()".}
proc trimStart*(this: String): String {.header: juce_core, importcpp: "#.trimStart()".}
proc trimEnd*(this: String): String {.header: juce_core, importcpp: "#.trimEnd()".}
proc trimCharactersAtStart*(this: String, charactersToTrim: StringRef): String {.header: juce_core, importcpp: "#.trimCharactersAtStart(@)".}
proc trimCharactersAtEnd*(this: String, charactersToTrim: StringRef): String {.header: juce_core, importcpp: "#.trimCharactersAtEnd(@)".}
proc toUpperCase*(this: String): String {.header: juce_core, importcpp: "#.toUpperCase()".}
proc toLowerCase*(this: String): String {.header: juce_core, importcpp: "#.toLowerCase()".}
proc replaceSection*(this: String, startIndex: cint, numCharactersToReplace: cint, stringToInsert: StringRef): String {.header: juce_core, importcpp: "#.replaceSection(@)".}
proc replace*(this: String, stringToReplace: StringRef, stringToInsertInstead: StringRef, ignoreCase: bool = false): String {.header: juce_core, importcpp: "#.replace(@)".}
proc replaceFirstOccurrenceOf*(this: String, stringToReplace: StringRef, stringToInsertInstead: StringRef, ignoreCase: bool = false): String {.header: juce_core, importcpp: "#.replaceFirstOccurrenceOf(@)".}
proc replaceCharacter*(this: String, characterToReplace: uint16, characterToInsertInstead: uint16): String {.header: juce_core, importcpp: "#.replaceCharacter(@)".}
proc replaceCharacters*(this: String, charactersToReplace: StringRef, charactersToInsertInstead: StringRef): String {.header: juce_core, importcpp: "#.replaceCharacters(@)".}
proc retainCharacters*(this: String, charactersToRetain: StringRef): String {.header: juce_core, importcpp: "#.retainCharacters(@)".}
proc removeCharacters*(this: String, charactersToRemove: StringRef): String {.header: juce_core, importcpp: "#.removeCharacters(@)".}
proc initialSectionContainingOnly*(this: String, permittedCharacters: StringRef): String {.header: juce_core, importcpp: "#.initialSectionContainingOnly(@)".}
proc initialSectionNotContaining*(this: String, charactersToStopAt: StringRef): String {.header: juce_core, importcpp: "#.initialSectionNotContaining(@)".}
proc isQuotedString*(this: String): bool {.header: juce_core, importcpp: "#.isQuotedString()".}
proc unquoted*(this: String): String {.header: juce_core, importcpp: "#.unquoted()".}
# proc quoted*(this: String, quoteCharacter: uint16): String {.header: juce_core, importcpp: "#.quoted(@)".}
proc paddedLeft*(this: String, padCharacter: uint16, minimumLength: cint): String {.header: juce_core, importcpp: "#.paddedLeft(@)".}
proc paddedRight*(this: String, padCharacter: uint16, minimumLength: cint): String {.header: juce_core, importcpp: "#.paddedRight(@)".}
# proc begin*(this: String): CharPointer_UTF8 {.header: juce_core, importcpp: "#.begin()".}
# proc `end`*(this: String): CharPointer_UTF8 {.header: juce_core, importcpp: "#.end()".}
proc getIntValue*(this: String): cint {.header: juce_core, importcpp: "#.getIntValue()".}
proc getLargeIntValue*(this: String): int64 {.header: juce_core, importcpp: "#.getLargeIntValue()".}
proc getTrailingIntValue*(this: String): cint {.header: juce_core, importcpp: "#.getTrailingIntValue()".}
proc getFloatValue*(this: String): cfloat {.header: juce_core, importcpp: "#.getFloatValue()".}
proc getDoubleValue*(this: String): float64 {.header: juce_core, importcpp: "#.getDoubleValue()".}
proc getHexValue32*(this: String): cint {.header: juce_core, importcpp: "#.getHexValue32()".}
proc getHexValue64*(this: String): int64 {.header: juce_core, importcpp: "#.getHexValue64()".}
proc getCharPointer*(this: String): CharPointer_UTF8 {.header: juce_core, importcpp: "#.getCharPointer()".}
proc toUTF8*(this: String): CharPointer_UTF8 {.header: juce_core, importcpp: "#.toUTF8()".}
proc toRawUTF8Impl*(this: String): constChar {.header: juce_core, importcpp: "#.toRawUTF8()".}
proc toUTF16*(this: String): CharPointer_UTF16 {.header: juce_core, importcpp: "#.toUTF16()".}
proc toUTF32*(this: String): CharPointer_UTF32 {.header: juce_core, importcpp: "#.toUTF32()".}
proc toWideCharPointer*(this: String): ptr uint16 {.header: juce_core, importcpp: "#.toWideCharPointer()".}
proc toStdString*(this: String): CppString {.header: juce_core, importcpp: "#.toStdString()".}
proc getNumBytesAsUTF8*(this: String): uint64 {.header: juce_core, importcpp: "#.getNumBytesAsUTF8()".}
proc copyToUTF8*(this: String, destBuffer: ptr char, maxBufferSizeBytes: uint64): uint64 {.header: juce_core, importcpp: "#.copyToUTF8(@)".}
proc copyToUTF16*(this: String, destBuffer: ptr int16, maxBufferSizeBytes: uint64): uint64 {.header: juce_core, importcpp: "#.copyToUTF16(@)".}
proc copyToUTF32*(this: String, destBuffer: ptr uint16, maxBufferSizeBytes: uint64): uint64 {.header: juce_core, importcpp: "#.copyToUTF32(@)".}
proc preallocateBytes*(this: var String, numBytesNeeded: uint64) {.header: juce_core, importcpp: "#.preallocateBytes(@)".}
proc swapWith*(this: var String, other: var String) {.header: juce_core, importcpp: "#.swapWith(@)".}
# proc toCFString*(this: String): ptr struct __CFString {.header: juce_core, importcpp: "#.toCFString()".}
proc convertToPrecomposedUnicode*(this: String): String {.header: juce_core, importcpp: "#.convertToPrecomposedUnicode()".}
proc getReferenceCount*(this: String): cint {.header: juce_core, importcpp: "#.getReferenceCount()".}

proc makeStringRef*(stringLiteral: constChar): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)".}
proc makeStringRef*(stringLiteral: CharPointer_UTF8): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)".}
proc makeStringRef*(string: String): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)".}
proc makeStringRef*(string: CppString): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)".}
proc makeStringRef*(): StringRef {.header: juce_core, importcpp: "juce::StringRef(@)".}
proc isEmpty*(this: StringRef): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isNotEmpty*(this: StringRef): bool {.header: juce_core, importcpp: "#.isNotEmpty()".}
proc length*(this: StringRef): cint {.header: juce_core, importcpp: "#.length()".}
proc `[]`*(this: StringRef, index: cint): uint16 {.header: juce_core, importcpp: "#.operator[](@)".}
proc `==`*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator<(@)".}
proc `<=`*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
# proc operator>*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator>(@)".}
# proc operator>=*(this: StringRef, s: String): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
proc `==`*(this: StringRef, s: StringRef): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: StringRef, s: StringRef): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc `==`*(this: Logger, other: Logger): bool {.error: "juce::Logger defines no operator==; compare a property instead".}

proc makeMemoryBlock*(): MemoryBlock {.header: juce_core, importcpp: "juce::MemoryBlock(@)".}
proc makeMemoryBlock*(initialSize: uint64, initialiseToZero: bool): MemoryBlock {.header: juce_core, importcpp: "juce::MemoryBlock(@)".}
proc makeMemoryBlock*(dataToInitialiseFrom: constPointer, sizeInBytes: uint64): MemoryBlock {.header: juce_core, importcpp: "juce::MemoryBlock(@)".}
proc `MemoryBlock=`*(this: var MemoryBlock, arg1: MemoryBlock): var MemoryBlock {.header: juce_core, importcpp: "#.operator=(@)".}
proc `MemoryBlock=`*(this: var MemoryBlock, arg1: lent MemoryBlock): var MemoryBlock {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: MemoryBlock, other: MemoryBlock): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MemoryBlock, other: MemoryBlock): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc matches*(this: MemoryBlock, data: constPointer, dataSize: uint64): bool {.header: juce_core, importcpp: "#.matches(@)".}
proc getData*(this: var MemoryBlock): pointer {.header: juce_core, importcpp: "#.getData()".}
proc getData*(this: MemoryBlock): constPointer {.header: juce_core, importcpp: "#.getData()".}
# proc begin*(this: var MemoryBlock): ptr char {.header: juce_core, importcpp: "#.begin()".}
# proc begin*(this: MemoryBlock): constChar {.header: juce_core, importcpp: "#.begin()".}
# proc `end`*(this: var MemoryBlock): ptr char {.header: juce_core, importcpp: "#.end()".}
# proc `end`*(this: MemoryBlock): constChar {.header: juce_core, importcpp: "#.end()".}
proc isEmpty*(this: MemoryBlock): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc getSize*(this: MemoryBlock): uint64 {.header: juce_core, importcpp: "#.getSize()".}
proc setSize*(this: var MemoryBlock, newSize: uint64, initialiseNewSpaceToZero: bool = false) {.header: juce_core, importcpp: "#.setSize(@)".}
proc ensureSize*(this: var MemoryBlock, minimumSize: uint64, initialiseNewSpaceToZero: bool = false) {.header: juce_core, importcpp: "#.ensureSize(@)".}
proc reset*(this: var MemoryBlock) {.header: juce_core, importcpp: "#.reset()".}
proc fillWith*(this: var MemoryBlock, valueToUse: uint8) {.header: juce_core, importcpp: "#.fillWith(@)".}
proc append*(this: var MemoryBlock, data: constPointer, numBytes: uint64) {.header: juce_core, importcpp: "#.append(@)".}
proc replaceAll*(this: var MemoryBlock, data: constPointer, numBytes: uint64) {.header: juce_core, importcpp: "#.replaceAll(@)".}
proc insert*(this: var MemoryBlock, dataToInsert: constPointer, numBytesToInsert: uint64, insertPosition: uint64) {.header: juce_core, importcpp: "#.insert(@)".}
proc removeSection*(this: var MemoryBlock, startByte: uint64, numBytesToRemove: uint64) {.header: juce_core, importcpp: "#.removeSection(@)".}
proc copyFrom*(this: var MemoryBlock, srcData: constPointer, destinationOffset: cint, numBytes: uint64) {.header: juce_core, importcpp: "#.copyFrom(@)".}
proc copyTo*(this: MemoryBlock, destData: pointer, sourceOffset: cint, numBytes: uint64) {.header: juce_core, importcpp: "#.copyTo(@)".}
proc swapWith*(this: var MemoryBlock, other: var MemoryBlock) {.header: juce_core, importcpp: "#.swapWith(@)".}
proc toString*(this: MemoryBlock): String {.header: juce_core, importcpp: "#.toString()".}
proc loadFromHexString*(this: var MemoryBlock, sourceHexString: StringRef) {.header: juce_core, importcpp: "#.loadFromHexString(@)".}
proc setBitRange*(this: var MemoryBlock, bitRangeStart: uint64, numBits: uint64, binaryNumberToApply: cint) {.header: juce_core, importcpp: "#.setBitRange(@)".}
proc getBitRange*(this: MemoryBlock, bitRangeStart: uint64, numBitsToRead: uint64): cint {.header: juce_core, importcpp: "#.getBitRange(@)".}
proc toBase64Encoding*(this: MemoryBlock): String {.header: juce_core, importcpp: "#.toBase64Encoding()".}
proc fromBase64Encoding*(this: var MemoryBlock, encodedString: StringRef): bool {.header: juce_core, importcpp: "#.fromBase64Encoding(@)".}
proc replaceWith*(this: var MemoryBlock, srcData: constPointer, numBytes: uint64) {.header: juce_core, importcpp: "#.replaceWith(@)".}

proc incReferenceCount*(this: var ReferenceCountedObject) {.header: juce_core, importcpp: "#.incReferenceCount()".}
proc decReferenceCount*(this: var ReferenceCountedObject) {.header: juce_core, importcpp: "#.decReferenceCount()".}
proc decReferenceCountWithoutDeleting*(this: var ReferenceCountedObject): bool {.header: juce_core, importcpp: "#.decReferenceCountWithoutDeleting()".}
proc getReferenceCount*(this: ReferenceCountedObject): cint {.header: juce_core, importcpp: "#.getReferenceCount()".}
proc `==`*(this: ReferenceCountedObject, other: ReferenceCountedObject): bool {.error: "juce::ReferenceCountedObject defines no operator==; compare a property instead".}

proc incReferenceCount*(this: var SingleThreadedReferenceCountedObject) {.header: juce_core, importcpp: "#.incReferenceCount()".}
proc decReferenceCount*(this: var SingleThreadedReferenceCountedObject) {.header: juce_core, importcpp: "#.decReferenceCount()".}
proc decReferenceCountWithoutDeleting*(this: var SingleThreadedReferenceCountedObject): bool {.header: juce_core, importcpp: "#.decReferenceCountWithoutDeleting()".}
proc getReferenceCount*(this: SingleThreadedReferenceCountedObject): cint {.header: juce_core, importcpp: "#.getReferenceCount()".}
proc `==`*(this: SingleThreadedReferenceCountedObject, other: SingleThreadedReferenceCountedObject): bool {.error: "juce::SingleThreadedReferenceCountedObject defines no operator==; compare a property instead".}

proc makeCriticalSection*(): CriticalSection {.header: juce_core, importcpp: "juce::CriticalSection(@)".}
proc enter*(this: CriticalSection) {.header: juce_core, importcpp: "#.enter()".}
proc tryEnter*(this: CriticalSection): bool {.header: juce_core, importcpp: "#.tryEnter()".}
proc exit*(this: CriticalSection) {.header: juce_core, importcpp: "#.exit()".}
proc `==`*(this: CriticalSection, other: CriticalSection): bool {.error: "juce::CriticalSection defines no operator==; compare a property instead".}

proc makeDummyCriticalSection*(): DummyCriticalSection {.header: juce_core, importcpp: "juce::DummyCriticalSection(@)".}
proc enter*(this: DummyCriticalSection) {.header: juce_core, importcpp: "#.enter()".}
proc tryEnter*(this: DummyCriticalSection): bool {.header: juce_core, importcpp: "#.tryEnter()".}
proc exit*(this: DummyCriticalSection) {.header: juce_core, importcpp: "#.exit()".}
proc `==`*(this: DummyCriticalSection, other: DummyCriticalSection): bool {.error: "juce::DummyCriticalSection defines no operator==; compare a property instead".}

proc `==`*(this: NullCheckedInvocation, other: NullCheckedInvocation): bool {.error: "juce::NullCheckedInvocation defines no operator==; compare a property instead".}

proc makeErasedScopeGuard*(): ErasedScopeGuard {.header: juce_core, importcpp: "juce::ErasedScopeGuard(@)".}
proc makeErasedScopeGuard*(d: CppFunctionObjectN0): ErasedScopeGuard {.header: juce_core, importcpp: "juce::ErasedScopeGuard(@)".}
proc `ErasedScopeGuard=`*(this: var ErasedScopeGuard, other: lent ErasedScopeGuard): var ErasedScopeGuard {.header: juce_core, importcpp: "#.operator=(@)".}
proc reset*(this: var ErasedScopeGuard) {.header: juce_core, importcpp: "#.reset()".}
proc release*(this: var ErasedScopeGuard) {.header: juce_core, importcpp: "#.release()".}
proc `ErasedScopeGuard=`*(this: var ErasedScopeGuard, arg1: ErasedScopeGuard): var ErasedScopeGuard {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: ErasedScopeGuard, other: ErasedScopeGuard): bool {.error: "juce::ErasedScopeGuard defines no operator==; compare a property instead".}

proc makeAbstractFifo*(bufferSize: cint): AbstractFifo {.header: juce_core, importcpp: "juce::AbstractFifo(@)".}
proc getTotalSize*(this: AbstractFifo): cint {.header: juce_core, importcpp: "#.getTotalSize()".}
proc getFreeSpace*(this: AbstractFifo): cint {.header: juce_core, importcpp: "#.getFreeSpace()".}
proc getNumReady*(this: AbstractFifo): cint {.header: juce_core, importcpp: "#.getNumReady()".}
proc reset*(this: var AbstractFifo) {.header: juce_core, importcpp: "#.reset()".}
proc setTotalSize*(this: var AbstractFifo, newSize: cint) {.header: juce_core, importcpp: "#.setTotalSize(@)".}
proc prepareToWrite*(this: AbstractFifo, numToWrite: cint, startIndex1: var cint, blockSize1: var cint, startIndex2: var cint, blockSize2: var cint) {.header: juce_core, importcpp: "#.prepareToWrite(@)".}
proc finishedWrite*(this: var AbstractFifo, numWritten: cint) {.header: juce_core, importcpp: "#.finishedWrite(@)".}
proc prepareToRead*(this: AbstractFifo, numWanted: cint, startIndex1: var cint, blockSize1: var cint, startIndex2: var cint, blockSize2: var cint) {.header: juce_core, importcpp: "#.prepareToRead(@)".}
proc finishedRead*(this: var AbstractFifo, numRead: cint) {.header: juce_core, importcpp: "#.finishedRead(@)".}
# proc read*(this: var AbstractFifo, numToRead: cint): ScopedRead {.header: juce_core, importcpp: "#.read(@)".}
# proc write*(this: var AbstractFifo, numToWrite: cint): ScopedWrite {.header: juce_core, importcpp: "#.write(@)".}
proc `==`*(this: AbstractFifo, other: AbstractFifo): bool {.error: "juce::AbstractFifo defines no operator==; compare a property instead".}

proc makeSingleThreadedAbstractFifo*(): SingleThreadedAbstractFifo {.header: juce_core, importcpp: "juce::SingleThreadedAbstractFifo(@)".}
proc makeSingleThreadedAbstractFifo*(sizeIn: cint): SingleThreadedAbstractFifo {.header: juce_core, importcpp: "juce::SingleThreadedAbstractFifo(@)".}
proc getRemainingSpace*(this: SingleThreadedAbstractFifo): cint {.header: juce_core, importcpp: "#.getRemainingSpace()".}
proc getNumReadable*(this: SingleThreadedAbstractFifo): cint {.header: juce_core, importcpp: "#.getNumReadable()".}
proc getSize*(this: SingleThreadedAbstractFifo): cint {.header: juce_core, importcpp: "#.getSize()".}
# proc write*(this: var SingleThreadedAbstractFifo, num: cint): std::array<Range<int>, 2> {.header: juce_core, importcpp: "#.write(@)".}
# proc read*(this: var SingleThreadedAbstractFifo, num: cint): std::array<Range<int>, 2> {.header: juce_core, importcpp: "#.read(@)".}
proc `==`*(this: SingleThreadedAbstractFifo, other: SingleThreadedAbstractFifo): bool {.error: "juce::SingleThreadedAbstractFifo defines no operator==; compare a property instead".}

proc `==`*(this: NewLine, other: NewLine): bool {.error: "juce::NewLine defines no operator==; compare a property instead".}

proc makeStringPool*(): StringPool {.header: juce_core, importcpp: "juce::StringPool(@)".}
proc getPooledString*(this: var StringPool, original: String): String {.header: juce_core, importcpp: "#.getPooledString(@)".}
proc getPooledString*(this: var StringPool, original: constChar): String {.header: juce_core, importcpp: "#.getPooledString(@)".}
proc getPooledString*(this: var StringPool, original: StringRef): String {.header: juce_core, importcpp: "#.getPooledString(@)".}
proc getPooledString*(this: var StringPool, start: CharPointer_UTF8, `end`: CharPointer_UTF8): String {.header: juce_core, importcpp: "#.getPooledString(@)".}
proc garbageCollect*(this: var StringPool) {.header: juce_core, importcpp: "#.garbageCollect()".}
proc `==`*(this: StringPool, other: StringPool): bool {.error: "juce::StringPool defines no operator==; compare a property instead".}

proc makeIdentifier*(): Identifier {.header: juce_core, importcpp: "juce::Identifier(@)".}
proc makeIdentifier*(name: String): Identifier {.header: juce_core, importcpp: "juce::Identifier(@)".}
proc makeIdentifier*(nameStart: CharPointer_UTF8, nameEnd: CharPointer_UTF8): Identifier {.header: juce_core, importcpp: "juce::Identifier(@)".}
proc `Identifier=`*(this: var Identifier, other: Identifier): var Identifier {.header: juce_core, importcpp: "#.operator=(@)".}
proc `Identifier=`*(this: var Identifier, other: lent Identifier): var Identifier {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: Identifier, other: Identifier): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Identifier, other: Identifier): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `==`*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator<(@)".}
proc `<=`*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
# proc operator>*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator>(@)".}
# proc operator>=*(this: Identifier, other: StringRef): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
proc toString*(this: Identifier): String {.header: juce_core, importcpp: "#.toString()".}
proc getCharPointer*(this: Identifier): CharPointer_UTF8 {.header: juce_core, importcpp: "#.getCharPointer()".}
proc isValid*(this: Identifier): bool {.header: juce_core, importcpp: "#.isValid()".}
proc isNull*(this: Identifier): bool {.header: juce_core, importcpp: "#.isNull()".}

proc makeStringArray*(): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(firstValue: String): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
# proc makeStringArray*(strings: std::initializer_list<constChar>): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(arg1: Array[String]): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(strings: ptr String, numberOfStrings: cint): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(strings: constChar, numberOfStrings: cint): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(strings: ptr uint16): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc makeStringArray*(strings: ptr uint16, numberOfStrings: cint): StringArray {.header: juce_core, importcpp: "juce::StringArray(@)".}
proc `StringArray=`*(this: var StringArray, arg1: StringArray): var StringArray {.header: juce_core, importcpp: "#.operator=(@)".}
proc `StringArray=`*(this: var StringArray, arg1: lent StringArray): var StringArray {.header: juce_core, importcpp: "#.operator=(@)".}
proc swapWith*(this: var StringArray, arg1: var StringArray) {.header: juce_core, importcpp: "#.swapWith(@)".}
proc `==`*(this: StringArray, arg1: StringArray): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: StringArray, arg1: StringArray): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc size*(this: StringArray): cint {.header: juce_core, importcpp: "#.size()".}
proc isEmpty*(this: StringArray): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc `[]`*(this: StringArray, index: cint): String {.header: juce_core, importcpp: "#.operator[](@)".}
proc getReference*(this: var StringArray, index: cint): var String {.header: juce_core, importcpp: "#.getReference(@)".}
proc getReference*(this: StringArray, index: cint): String {.header: juce_core, importcpp: "#.getReference(@)".}
# proc begin*(this: var StringArray): ptr String {.header: juce_core, importcpp: "#.begin()".}
# proc begin*(this: StringArray): ptr String {.header: juce_core, importcpp: "#.begin()".}
# proc `end`*(this: var StringArray): ptr String {.header: juce_core, importcpp: "#.end()".}
# proc `end`*(this: StringArray): ptr String {.header: juce_core, importcpp: "#.end()".}
proc contains*(this: StringArray, stringToLookFor: StringRef, ignoreCase: bool = false): bool {.header: juce_core, importcpp: "#.contains(@)".}
proc indexOf*(this: StringArray, stringToLookFor: StringRef, ignoreCase: bool = false, startIndex: cint = 0): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc add*(this: var StringArray, stringToAdd: String) {.header: juce_core, importcpp: "#.add(@)".}
proc insert*(this: var StringArray, index: cint, stringToAdd: String) {.header: juce_core, importcpp: "#.insert(@)".}
proc addIfNotAlreadyThere*(this: var StringArray, stringToAdd: String, ignoreCase: bool = false): bool {.header: juce_core, importcpp: "#.addIfNotAlreadyThere(@)".}
proc set*(this: var StringArray, index: cint, newString: String) {.header: juce_core, importcpp: "#.set(@)".}
proc addArray*(this: var StringArray, other: StringArray, startIndex: cint = 0, numElementsToAdd: cint = -1) {.header: juce_core, importcpp: "#.addArray(@)".}
proc mergeArray*(this: var StringArray, other: StringArray, ignoreCase: bool = false) {.header: juce_core, importcpp: "#.mergeArray(@)".}
proc addTokens*(this: var StringArray, stringToTokenise: StringRef, preserveQuotedStrings: bool): cint {.header: juce_core, importcpp: "#.addTokens(@)".}
proc addTokens*(this: var StringArray, stringToTokenise: StringRef, breakCharacters: StringRef, quoteCharacters: StringRef): cint {.header: juce_core, importcpp: "#.addTokens(@)".}
proc addLines*(this: var StringArray, stringToBreakUp: StringRef): cint {.header: juce_core, importcpp: "#.addLines(@)".}
proc clear*(this: var StringArray) {.header: juce_core, importcpp: "#.clear()".}
proc clearQuick*(this: var StringArray) {.header: juce_core, importcpp: "#.clearQuick()".}
proc remove*(this: var StringArray, index: cint) {.header: juce_core, importcpp: "#.remove(@)".}
proc removeString*(this: var StringArray, stringToRemove: StringRef, ignoreCase: bool = false) {.header: juce_core, importcpp: "#.removeString(@)".}
proc removeRange*(this: var StringArray, startIndex: cint, numberToRemove: cint) {.header: juce_core, importcpp: "#.removeRange(@)".}
proc removeDuplicates*(this: var StringArray, ignoreCase: bool) {.header: juce_core, importcpp: "#.removeDuplicates(@)".}
proc removeEmptyStrings*(this: var StringArray, removeWhitespaceStrings: bool = true) {.header: juce_core, importcpp: "#.removeEmptyStrings(@)".}
proc move*(this: var StringArray, currentIndex: cint, newIndex: cint) {.header: juce_core, importcpp: "#.move(@)".}
proc trim*(this: var StringArray) {.header: juce_core, importcpp: "#.trim()".}
# proc appendNumbersToDuplicates*(this: var StringArray, ignoreCaseWhenComparing: bool, appendNumberToFirstInstance: bool, preNumberString: CharPointer_UTF8, postNumberString: CharPointer_UTF8) {.header: juce_core, importcpp: "#.appendNumbersToDuplicates(@)".}
proc joinIntoString*(this: StringArray, separatorString: StringRef, startIndex: cint = 0, numberOfElements: cint = -1): String {.header: juce_core, importcpp: "#.joinIntoString(@)".}
proc sort*(this: var StringArray, ignoreCase: bool) {.header: juce_core, importcpp: "#.sort(@)".}
proc sortNatural*(this: var StringArray) {.header: juce_core, importcpp: "#.sortNatural()".}
proc ensureStorageAllocated*(this: var StringArray, minNumElements: cint) {.header: juce_core, importcpp: "#.ensureStorageAllocated(@)".}
proc minimiseStorageOverheads*(this: var StringArray) {.header: juce_core, importcpp: "#.minimiseStorageOverheads()".}

proc `==`*(this: SystemStats, other: SystemStats): bool {.error: "juce::SystemStats defines no operator==; compare a property instead".}

proc makeStringPairArray*(ignoreCaseWhenComparingKeys: bool): StringPairArray {.header: juce_core, importcpp: "juce::StringPairArray(@)".}
proc `StringPairArray=`*(this: var StringPairArray, other: StringPairArray): var StringPairArray {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: StringPairArray, other: StringPairArray): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: StringPairArray, other: StringPairArray): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `[]`*(this: StringPairArray, key: StringRef): String {.header: juce_core, importcpp: "#.operator[](@)".}
proc getValue*(this: StringPairArray, arg1: StringRef, defaultReturnValue: String): String {.header: juce_core, importcpp: "#.getValue(@)".}
proc containsKey*(this: StringPairArray, key: StringRef): bool {.header: juce_core, importcpp: "#.containsKey(@)".}
proc getAllKeys*(this: StringPairArray): StringArray {.header: juce_core, importcpp: "#.getAllKeys()".}
proc getAllValues*(this: StringPairArray): StringArray {.header: juce_core, importcpp: "#.getAllValues()".}
proc size*(this: StringPairArray): cint {.header: juce_core, importcpp: "#.size()".}
proc set*(this: var StringPairArray, key: String, value: String) {.header: juce_core, importcpp: "#.set(@)".}
proc addArray*(this: var StringPairArray, other: StringPairArray) {.header: juce_core, importcpp: "#.addArray(@)".}
proc clear*(this: var StringPairArray) {.header: juce_core, importcpp: "#.clear()".}
proc remove*(this: var StringPairArray, key: StringRef) {.header: juce_core, importcpp: "#.remove(@)".}
proc remove*(this: var StringPairArray, index: cint) {.header: juce_core, importcpp: "#.remove(@)".}
proc setIgnoresCase*(this: var StringPairArray, shouldIgnoreCase: bool) {.header: juce_core, importcpp: "#.setIgnoresCase(@)".}
proc getIgnoresCase*(this: StringPairArray): bool {.header: juce_core, importcpp: "#.getIgnoresCase()".}
proc getDescription*(this: StringPairArray): String {.header: juce_core, importcpp: "#.getDescription()".}
proc minimiseStorageOverheads*(this: var StringPairArray) {.header: juce_core, importcpp: "#.minimiseStorageOverheads()".}
# proc addMap*(this: var StringPairArray, mapToAdd: std::map<String, String>) {.header: juce_core, importcpp: "#.addMap(@)".}
# proc addUnorderedMap*(this: var StringPairArray, mapToAdd: std::unordered_map<String, String>) {.header: juce_core, importcpp: "#.addUnorderedMap(@)".}

proc makeTextDiff*(original: String, target: String): TextDiff {.header: juce_core, importcpp: "juce::TextDiff(@)".}
proc appliedTo*(this: TextDiff, text: String): String {.header: juce_core, importcpp: "#.appliedTo(@)".}
proc `==`*(this: TextDiff, other: TextDiff): bool {.error: "juce::TextDiff defines no operator==; compare a property instead".}

proc makeLocalisedStrings*(fileContents: String, ignoreCaseOfKeys: bool): LocalisedStrings {.header: juce_core, importcpp: "juce::LocalisedStrings(@)".}
proc makeLocalisedStrings*(fileToLoad: File, ignoreCaseOfKeys: bool): LocalisedStrings {.header: juce_core, importcpp: "juce::LocalisedStrings(@)".}
proc `LocalisedStrings=`*(this: var LocalisedStrings, arg1: LocalisedStrings): var LocalisedStrings {.header: juce_core, importcpp: "#.operator=(@)".}
proc translate*(this: LocalisedStrings, text: String): String {.header: juce_core, importcpp: "#.translate(@)".}
proc translate*(this: LocalisedStrings, text: String, resultIfNotFound: String): String {.header: juce_core, importcpp: "#.translate(@)".}
proc getLanguageName*(this: LocalisedStrings): String {.header: juce_core, importcpp: "#.getLanguageName()".}
proc getCountryCodes*(this: LocalisedStrings): StringArray {.header: juce_core, importcpp: "#.getCountryCodes()".}
proc getMappings*(this: LocalisedStrings): StringPairArray {.header: juce_core, importcpp: "#.getMappings()".}
proc addStrings*(this: var LocalisedStrings, arg1: LocalisedStrings) {.header: juce_core, importcpp: "#.addStrings(@)".}
proc setFallback*(this: var LocalisedStrings, fallbackStrings: ptr LocalisedStrings) {.header: juce_core, importcpp: "#.setFallback(@)".}
proc `==`*(this: LocalisedStrings, other: LocalisedStrings): bool {.error: "juce::LocalisedStrings defines no operator==; compare a property instead".}

proc `==`*(this: Base64, other: Base64): bool {.error: "juce::Base64 defines no operator==; compare a property instead".}

proc wasOk*(this: Result): bool {.header: juce_core, importcpp: "#.wasOk()".}
proc failed*(this: Result): bool {.header: juce_core, importcpp: "#.failed()".}
# proc operator!*(this: Result): bool {.header: juce_core, importcpp: "#.operator!()".}
proc getErrorMessage*(this: Result): String {.header: juce_core, importcpp: "#.getErrorMessage()".}
proc `Result=`*(this: var Result, arg1: Result): var Result {.header: juce_core, importcpp: "#.operator=(@)".}
proc `Result=`*(this: var Result, arg1: lent Result): var Result {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: Result, other: Result): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Result, other: Result): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc makeUuid*(): Uuid {.header: juce_core, importcpp: "juce::Uuid(@)".}
proc makeUuid*(uuidString: String): Uuid {.header: juce_core, importcpp: "juce::Uuid(@)".}
proc makeUuid*(rawData: ptr uint8): Uuid {.header: juce_core, importcpp: "juce::Uuid(@)".}
proc `Uuid=`*(this: var Uuid, arg1: Uuid): var Uuid {.header: juce_core, importcpp: "#.operator=(@)".}
proc isNull*(this: Uuid): bool {.header: juce_core, importcpp: "#.isNull()".}
proc `==`*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc `<=`*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
# proc operator>=*(this: Uuid, arg1: Uuid): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
proc toString*(this: Uuid): String {.header: juce_core, importcpp: "#.toString()".}
proc toDashedString*(this: Uuid): String {.header: juce_core, importcpp: "#.toDashedString()".}
proc `Uuid=`*(this: var Uuid, uuidString: String): var Uuid {.header: juce_core, importcpp: "#.operator=(@)".}
proc getTimeLow*(this: Uuid): uint32 {.header: juce_core, importcpp: "#.getTimeLow()".}
proc getTimeMid*(this: Uuid): uint16 {.header: juce_core, importcpp: "#.getTimeMid()".}
proc getTimeHighAndVersion*(this: Uuid): uint16 {.header: juce_core, importcpp: "#.getTimeHighAndVersion()".}
proc getClockSeqAndReserved*(this: Uuid): uint8 {.header: juce_core, importcpp: "#.getClockSeqAndReserved()".}
proc getClockSeqLow*(this: Uuid): uint8 {.header: juce_core, importcpp: "#.getClockSeqLow()".}
proc getNode*(this: Uuid): uint64 {.header: juce_core, importcpp: "#.getNode()".}
proc hash*(this: Uuid): uint64 {.header: juce_core, importcpp: "#.hash()".}
proc getRawData*(this: Uuid): ptr uint8 {.header: juce_core, importcpp: "#.getRawData()".}
proc `Uuid=`*(this: var Uuid, rawData: ptr uint8): var Uuid {.header: juce_core, importcpp: "#.operator=(@)".}

proc makeArgumentList*(executable: String, arguments: StringArray): ArgumentList {.header: juce_core, importcpp: "juce::ArgumentList(@)".}
# proc makeArgumentList*(argc: cint, argv: ptr char[]): ArgumentList {.header: juce_core, importcpp: "juce::ArgumentList(@)".}
proc makeArgumentList*(executable: String, arguments: String): ArgumentList {.header: juce_core, importcpp: "juce::ArgumentList(@)".}
proc `ArgumentList=`*(this: var ArgumentList, arg1: ArgumentList): var ArgumentList {.header: juce_core, importcpp: "#.operator=(@)".}
proc size*(this: ArgumentList): cint {.header: juce_core, importcpp: "#.size()".}
proc `[]`*(this: ArgumentList, index: cint): ArgumentListArgument {.header: juce_core, importcpp: "#.operator[](@)".}
proc checkMinNumArguments*(this: ArgumentList, expectedMinNumberOfArgs: cint) {.header: juce_core, importcpp: "#.checkMinNumArguments(@)".}
proc containsOption*(this: ArgumentList, option: StringRef): bool {.header: juce_core, importcpp: "#.containsOption(@)".}
proc removeOptionIfFound*(this: var ArgumentList, option: StringRef): bool {.header: juce_core, importcpp: "#.removeOptionIfFound(@)".}
proc indexOfOption*(this: ArgumentList, option: StringRef): cint {.header: juce_core, importcpp: "#.indexOfOption(@)".}
proc failIfOptionIsMissing*(this: ArgumentList, option: StringRef) {.header: juce_core, importcpp: "#.failIfOptionIsMissing(@)".}
proc getValueForOption*(this: ArgumentList, option: StringRef): String {.header: juce_core, importcpp: "#.getValueForOption(@)".}
proc removeValueForOption*(this: var ArgumentList, option: StringRef): String {.header: juce_core, importcpp: "#.removeValueForOption(@)".}
proc getFileForOption*(this: ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getFileForOption(@)".}
proc getFileForOptionAndRemove*(this: var ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getFileForOptionAndRemove(@)".}
proc getExistingFileForOption*(this: ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getExistingFileForOption(@)".}
proc getExistingFileForOptionAndRemove*(this: var ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getExistingFileForOptionAndRemove(@)".}
proc getExistingFolderForOption*(this: ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getExistingFolderForOption(@)".}
proc getExistingFolderForOptionAndRemove*(this: var ArgumentList, option: StringRef): File {.header: juce_core, importcpp: "#.getExistingFolderForOptionAndRemove(@)".}
proc `==`*(this: ArgumentList, other: ArgumentList): bool {.error: "juce::ArgumentList defines no operator==; compare a property instead".}

proc addCommand*(this: var ConsoleApplication, arg1: ConsoleApplicationCommand) {.header: juce_core, importcpp: "#.addCommand(@)".}
proc addDefaultCommand*(this: var ConsoleApplication, arg1: ConsoleApplicationCommand) {.header: juce_core, importcpp: "#.addDefaultCommand(@)".}
proc addVersionCommand*(this: var ConsoleApplication, versionArgument: String, versionText: String) {.header: juce_core, importcpp: "#.addVersionCommand(@)".}
proc addHelpCommand*(this: var ConsoleApplication, helpArgument: String, helpMessage: String, makeDefaultCommand: bool) {.header: juce_core, importcpp: "#.addHelpCommand(@)".}
proc printCommandList*(this: ConsoleApplication, arg1: ArgumentList) {.header: juce_core, importcpp: "#.printCommandList(@)".}
proc printCommandDetails*(this: ConsoleApplication, arg1: ArgumentList, arg2: ConsoleApplicationCommand) {.header: juce_core, importcpp: "#.printCommandDetails(@)".}
# proc findAndRunCommand*(this: ConsoleApplication, arg1: ArgumentList, optionMustBeFirstArg: bool = false): cint {.header: juce_core, importcpp: "#.findAndRunCommand(@)".}
# proc findAndRunCommand*(this: ConsoleApplication, argc: cint, argv: ptr char[]): cint {.header: juce_core, importcpp: "#.findAndRunCommand(@)".}
proc findCommand*(this: ConsoleApplication, arg1: ArgumentList, optionMustBeFirstArg: bool): ptr ConsoleApplicationCommand {.header: juce_core, importcpp: "#.findCommand(@)".}
proc getCommands*(this: ConsoleApplication): CppVector[ConsoleApplicationCommand] {.header: juce_core, importcpp: "#.getCommands()".}
proc `==`*(this: ConsoleApplication, other: ConsoleApplication): bool {.error: "juce::ConsoleApplication defines no operator==; compare a property instead".}

proc makejuce_var*(): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: cint): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: int64): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: bool): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: float64): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: ptr uint16): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: String): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: Array[juce_var]): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(value: StringArray): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(`object`: ptr ReferenceCountedObject): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(`method`: CppFunctionObjectR1[juce_var, juce_varNativeFunctionArgs]): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(binaryData: constPointer, dataSize: uint64): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(binaryData: MemoryBlock): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(arg1: lent String): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(arg1: lent MemoryBlock): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc makejuce_var*(arg1: Array[juce_var]): juce_var {.header: juce_core, importcpp: "juce::var(@)".}
proc `juce_var=`*(this: var juce_var, valueToCopy: juce_var): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: cint): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: int64): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: bool): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: float64): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: constChar): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: ptr uint16): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: String): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: MemoryBlock): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, value: Array[juce_var]): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, `object`: ptr ReferenceCountedObject): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, `method`: CppFunctionObjectR1[juce_var, juce_varNativeFunctionArgs]): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, arg1: lent juce_var): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc `juce_var=`*(this: var juce_var, arg1: lent String): var juce_var {.header: juce_core, importcpp: "#.operator=(@)".}
proc swapWith*(this: var juce_var, other: var juce_var) {.header: juce_core, importcpp: "#.swapWith(@)".}
proc toString*(this: juce_var): String {.header: juce_core, importcpp: "#.toString()".}
proc getArray*(this: juce_var): ptr Array[juce_var] {.header: juce_core, importcpp: "#.getArray()".}
proc getBinaryData*(this: juce_var): ptr MemoryBlock {.header: juce_core, importcpp: "#.getBinaryData()".}
proc getObject*(this: juce_var): ptr ReferenceCountedObject {.header: juce_core, importcpp: "#.getObject()".}
proc getDynamicObject*(this: juce_var): ptr DynamicObject {.header: juce_core, importcpp: "#.getDynamicObject()".}
proc isVoid*(this: juce_var): bool {.header: juce_core, importcpp: "#.isVoid()".}
proc isUndefined*(this: juce_var): bool {.header: juce_core, importcpp: "#.isUndefined()".}
proc isInt*(this: juce_var): bool {.header: juce_core, importcpp: "#.isInt()".}
proc isInt64*(this: juce_var): bool {.header: juce_core, importcpp: "#.isInt64()".}
proc isBool*(this: juce_var): bool {.header: juce_core, importcpp: "#.isBool()".}
proc isDouble*(this: juce_var): bool {.header: juce_core, importcpp: "#.isDouble()".}
proc isString*(this: juce_var): bool {.header: juce_core, importcpp: "#.isString()".}
proc isObject*(this: juce_var): bool {.header: juce_core, importcpp: "#.isObject()".}
proc isArray*(this: juce_var): bool {.header: juce_core, importcpp: "#.isArray()".}
proc isBinaryData*(this: juce_var): bool {.header: juce_core, importcpp: "#.isBinaryData()".}
proc isMethod*(this: juce_var): bool {.header: juce_core, importcpp: "#.isMethod()".}
proc getArrayElements*(this: var juce_var): Span[juce_var] {.header: juce_core, importcpp: "#.getArrayElements()".}
proc getArrayElements*(this: juce_var): Span[juce_var] {.header: juce_core, importcpp: "#.getArrayElements()".}
proc getObjectElements*(this: var juce_var): Span[NamedValue] {.header: juce_core, importcpp: "#.getObjectElements()".}
proc getObjectElements*(this: juce_var): Span[NamedValue] {.header: juce_core, importcpp: "#.getObjectElements()".}
proc equals*(this: juce_var, other: juce_var): bool {.header: juce_core, importcpp: "#.equals(@)".}
proc equalsWithSameType*(this: juce_var, other: juce_var): bool {.header: juce_core, importcpp: "#.equalsWithSameType(@)".}
proc hasSameTypeAs*(this: juce_var, other: juce_var): bool {.header: juce_core, importcpp: "#.hasSameTypeAs(@)".}
proc clone*(this: juce_var): juce_var {.header: juce_core, importcpp: "#.clone()".}
proc size*(this: juce_var): cint {.header: juce_core, importcpp: "#.size()".}
proc `[]`*(this: juce_var, arrayIndex: cint): juce_var {.header: juce_core, importcpp: "#.operator[](@)".}
proc `[]`*(this: var juce_var, arrayIndex: cint): var juce_var {.header: juce_core, importcpp: "#.operator[](@)".}
proc append*(this: var juce_var, valueToAppend: juce_var) {.header: juce_core, importcpp: "#.append(@)".}
proc insert*(this: var juce_var, index: cint, value: juce_var) {.header: juce_core, importcpp: "#.insert(@)".}
proc remove*(this: var juce_var, index: cint) {.header: juce_core, importcpp: "#.remove(@)".}
proc resize*(this: var juce_var, numArrayElementsWanted: cint) {.header: juce_core, importcpp: "#.resize(@)".}
proc indexOf*(this: juce_var, value: juce_var): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc `[]`*(this: juce_var, propertyName: Identifier): juce_var {.header: juce_core, importcpp: "#.operator[](@)".}
proc `[]`*(this: juce_var, propertyName: constChar): juce_var {.header: juce_core, importcpp: "#.operator[](@)".}
proc getProperty*(this: juce_var, propertyName: Identifier, defaultReturnValue: juce_var): juce_var {.header: juce_core, importcpp: "#.getProperty(@)".}
proc hasProperty*(this: juce_var, propertyName: Identifier): bool {.header: juce_core, importcpp: "#.hasProperty(@)".}
proc call*(this: juce_var, `method`: Identifier): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc call*(this: juce_var, `method`: Identifier, arg1: juce_var): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc call*(this: juce_var, `method`: Identifier, arg1: juce_var, arg2: juce_var): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc call*(this: var juce_var, `method`: Identifier, arg1: juce_var, arg2: juce_var, arg3: juce_var): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc call*(this: juce_var, `method`: Identifier, arg1: juce_var, arg2: juce_var, arg3: juce_var, arg4: juce_var): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc call*(this: juce_var, `method`: Identifier, arg1: juce_var, arg2: juce_var, arg3: juce_var, arg4: juce_var, arg5: juce_var): juce_var {.header: juce_core, importcpp: "#.call(@)".}
proc invoke*(this: juce_var, `method`: Identifier, arguments: ptr juce_var, numArguments: cint): juce_var {.header: juce_core, importcpp: "#.invoke(@)".}
proc getNativeFunction*(this: juce_var): CppFunctionObjectR1[juce_var, juce_varNativeFunctionArgs] {.header: juce_core, importcpp: "#.getNativeFunction()".}
proc writeToStream*(this: juce_var, output: var OutputStream) {.header: juce_core, importcpp: "#.writeToStream(@)".}

proc `==`*(this: NamedValue, arg1: NamedValue): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: NamedValue, arg1: NamedValue): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc makeNamedValueSet*(): NamedValueSet {.header: juce_core, importcpp: "juce::NamedValueSet(@)".}
# proc makeNamedValueSet*(arg1: std::initializer_list<NamedValue>): NamedValueSet {.header: juce_core, importcpp: "juce::NamedValueSet(@)".}
proc `==`*(this: NamedValueSet, arg1: NamedValueSet): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: NamedValueSet, arg1: NamedValueSet): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
# proc begin*(this: NamedValueSet): ptr NamedValue {.header: juce_core, importcpp: "#.begin()".}
# proc `end`*(this: NamedValueSet): ptr NamedValue {.header: juce_core, importcpp: "#.end()".}
proc asSpan*(this: var NamedValueSet): Span[NamedValue] {.header: juce_core, importcpp: "#.asSpan()".}
proc asSpan*(this: NamedValueSet): Span[NamedValue] {.header: juce_core, importcpp: "#.asSpan()".}
proc size*(this: NamedValueSet): cint {.header: juce_core, importcpp: "#.size()".}
proc isEmpty*(this: NamedValueSet): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc `[]`*(this: NamedValueSet, name: Identifier): juce_var {.header: juce_core, importcpp: "#.operator[](@)".}
proc getWithDefault*(this: NamedValueSet, name: Identifier, defaultReturnValue: juce_var): juce_var {.header: juce_core, importcpp: "#.getWithDefault(@)".}
proc set*(this: var NamedValueSet, name: Identifier, newValue: juce_var): bool {.header: juce_core, importcpp: "#.set(@)".}
proc set*(this: var NamedValueSet, name: Identifier, newValue: lent juce_var): bool {.header: juce_core, importcpp: "#.set(@)".}
proc contains*(this: NamedValueSet, name: Identifier): bool {.header: juce_core, importcpp: "#.contains(@)".}
proc remove*(this: var NamedValueSet, name: Identifier): bool {.header: juce_core, importcpp: "#.remove(@)".}
proc getName*(this: NamedValueSet, index: cint): Identifier {.header: juce_core, importcpp: "#.getName(@)".}
proc getVarPointer*(this: var NamedValueSet, name: Identifier): ptr juce_var {.header: juce_core, importcpp: "#.getVarPointer(@)".}
proc getVarPointer*(this: NamedValueSet, name: Identifier): ptr juce_var {.header: juce_core, importcpp: "#.getVarPointer(@)".}
proc getValueAt*(this: NamedValueSet, index: cint): juce_var {.header: juce_core, importcpp: "#.getValueAt(@)".}
proc getVarPointerAt*(this: var NamedValueSet, index: cint): ptr juce_var {.header: juce_core, importcpp: "#.getVarPointerAt(@)".}
proc getVarPointerAt*(this: NamedValueSet, index: cint): ptr juce_var {.header: juce_core, importcpp: "#.getVarPointerAt(@)".}
proc indexOf*(this: NamedValueSet, name: Identifier): cint {.header: juce_core, importcpp: "#.indexOf(@)".}
proc clear*(this: var NamedValueSet) {.header: juce_core, importcpp: "#.clear()".}
proc setFromXmlAttributes*(this: var NamedValueSet, xml: XmlElement) {.header: juce_core, importcpp: "#.setFromXmlAttributes(@)".}
proc copyToXmlAttributes*(this: NamedValueSet, xml: var XmlElement) {.header: juce_core, importcpp: "#.copyToXmlAttributes(@)".}

proc `==`*(this: JSON, other: JSON): bool {.error: "juce::JSON defines no operator==; compare a property instead".}

proc makeDynamicObject*(): DynamicObject {.header: juce_core, importcpp: "juce::DynamicObject(@)".}
proc hasProperty*(this: DynamicObject, propertyName: Identifier): bool {.header: juce_core, importcpp: "#.hasProperty(@)".}
proc getProperty*(this: DynamicObject, propertyName: Identifier): juce_var {.header: juce_core, importcpp: "#.getProperty(@)".}
proc setProperty*(this: var DynamicObject, propertyName: Identifier, newValue: juce_var) {.header: juce_core, importcpp: "#.setProperty(@)".}
proc removeProperty*(this: var DynamicObject, propertyName: Identifier) {.header: juce_core, importcpp: "#.removeProperty(@)".}
proc hasMethod*(this: DynamicObject, methodName: Identifier): bool {.header: juce_core, importcpp: "#.hasMethod(@)".}
proc invokeMethod*(this: var DynamicObject, methodName: Identifier, args: juce_varNativeFunctionArgs): juce_var {.header: juce_core, importcpp: "#.invokeMethod(@)".}
# proc setMethod*(this: var DynamicObject, methodName: Identifier, function: CppFunctionObjectR1[juce_var, NativeFunctionArgs]) {.header: juce_core, importcpp: "#.setMethod(@)".}
proc clear*(this: var DynamicObject) {.header: juce_core, importcpp: "#.clear()".}
proc getProperties*(this: var DynamicObject): var NamedValueSet {.header: juce_core, importcpp: "#.getProperties()".}
proc getProperties*(this: DynamicObject): NamedValueSet {.header: juce_core, importcpp: "#.getProperties()".}
proc cloneAllProperties*(this: var DynamicObject) {.header: juce_core, importcpp: "#.cloneAllProperties()".}
# proc clone*(this: DynamicObject): UniquePtr[DynamicObject] {.header: juce_core, importcpp: "#.clone()".}
proc writeAsJSON*(this: var DynamicObject, arg1: var OutputStream, arg2: JSONFormatOptions) {.header: juce_core, importcpp: "#.writeAsJSON(@)".}
proc equals*(this: DynamicObject, other: DynamicObject): bool {.header: juce_core, importcpp: "#.equals(@)".}
proc `==`*(this: DynamicObject, other: DynamicObject): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: DynamicObject, other: DynamicObject): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc `==`*(this: DefaultHashFunctions, other: DefaultHashFunctions): bool {.error: "juce::DefaultHashFunctions defines no operator==; compare a property instead".}

proc makeRelativeTime*(): RelativeTime {.header: juce_core, importcpp: "juce::RelativeTime(@)".}
proc makeRelativeTime*(seconds: float64): RelativeTime {.header: juce_core, importcpp: "juce::RelativeTime(@)".}
proc `RelativeTime=`*(this: var RelativeTime, other: RelativeTime): var RelativeTime {.header: juce_core, importcpp: "#.operator=(@)".}
proc inMilliseconds*(this: RelativeTime): int64 {.header: juce_core, importcpp: "#.inMilliseconds()".}
proc inSeconds*(this: RelativeTime): float64 {.header: juce_core, importcpp: "#.inSeconds()".}
proc inMinutes*(this: RelativeTime): float64 {.header: juce_core, importcpp: "#.inMinutes()".}
proc inHours*(this: RelativeTime): float64 {.header: juce_core, importcpp: "#.inHours()".}
proc inDays*(this: RelativeTime): float64 {.header: juce_core, importcpp: "#.inDays()".}
proc inWeeks*(this: RelativeTime): float64 {.header: juce_core, importcpp: "#.inWeeks()".}
# proc getDescription*(this: RelativeTime, returnValueForZeroTime: String): String {.header: juce_core, importcpp: "#.getDescription(@)".}
proc getApproximateDescription*(this: RelativeTime): String {.header: juce_core, importcpp: "#.getApproximateDescription()".}
proc `+=`*(this: var RelativeTime, timeToAdd: RelativeTime) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var RelativeTime, timeToSubtract: RelativeTime) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `+=`*(this: var RelativeTime, secondsToAdd: float64) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var RelativeTime, secondsToSubtract: float64) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `==`*(this: RelativeTime, other: RelativeTime): bool {.error: "juce::RelativeTime defines no operator==; compare a property instead".}

proc makeTime*(): Time {.header: juce_core, importcpp: "juce::Time(@)".}
proc makeTime*(millisecondsSinceEpoch: int64): Time {.header: juce_core, importcpp: "juce::Time(@)".}
proc makeTime*(year: cint, month: cint, day: cint, hours: cint, minutes: cint, seconds: cint, milliseconds: cint, useLocalTime: bool): Time {.header: juce_core, importcpp: "juce::Time(@)".}
proc `Time=`*(this: var Time, arg1: Time): var Time {.header: juce_core, importcpp: "#.operator=(@)".}
proc toMilliseconds*(this: Time): int64 {.header: juce_core, importcpp: "#.toMilliseconds()".}
proc getYear*(this: Time): cint {.header: juce_core, importcpp: "#.getYear()".}
proc getMonth*(this: Time): cint {.header: juce_core, importcpp: "#.getMonth()".}
proc getMonthName*(this: Time, threeLetterVersion: bool): String {.header: juce_core, importcpp: "#.getMonthName(@)".}
proc getDayOfMonth*(this: Time): cint {.header: juce_core, importcpp: "#.getDayOfMonth()".}
proc getDayOfWeek*(this: Time): cint {.header: juce_core, importcpp: "#.getDayOfWeek()".}
proc getDayOfYear*(this: Time): cint {.header: juce_core, importcpp: "#.getDayOfYear()".}
proc getWeekdayName*(this: Time, threeLetterVersion: bool): String {.header: juce_core, importcpp: "#.getWeekdayName(@)".}
proc getHours*(this: Time): cint {.header: juce_core, importcpp: "#.getHours()".}
proc isAfternoon*(this: Time): bool {.header: juce_core, importcpp: "#.isAfternoon()".}
proc getHoursInAmPmFormat*(this: Time): cint {.header: juce_core, importcpp: "#.getHoursInAmPmFormat()".}
proc getMinutes*(this: Time): cint {.header: juce_core, importcpp: "#.getMinutes()".}
proc getSeconds*(this: Time): cint {.header: juce_core, importcpp: "#.getSeconds()".}
proc getMilliseconds*(this: Time): cint {.header: juce_core, importcpp: "#.getMilliseconds()".}
proc isDaylightSavingTime*(this: Time): bool {.header: juce_core, importcpp: "#.isDaylightSavingTime()".}
proc getTimeZone*(this: Time): String {.header: juce_core, importcpp: "#.getTimeZone()".}
proc getUTCOffsetSeconds*(this: Time): cint {.header: juce_core, importcpp: "#.getUTCOffsetSeconds()".}
proc getUTCOffsetString*(this: Time, includeDividerCharacters: bool): String {.header: juce_core, importcpp: "#.getUTCOffsetString(@)".}
proc toString*(this: Time, includeDate: bool, includeTime: bool, includeSeconds: bool = true, use24HourClock: bool = false): String {.header: juce_core, importcpp: "#.toString(@)".}
proc formatted*(this: Time, format: String): String {.header: juce_core, importcpp: "#.formatted(@)".}
proc toISO8601*(this: Time, includeDividerCharacters: bool): String {.header: juce_core, importcpp: "#.toISO8601(@)".}
proc `+=`*(this: var Time, delta: RelativeTime) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var Time, delta: RelativeTime) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc setSystemTimeToThisTime*(this: Time): bool {.header: juce_core, importcpp: "#.setSystemTimeToThisTime()".}
proc `==`*(this: Time, other: Time): bool {.error: "juce::Time defines no operator==; compare a property instead".}

proc getTotalLength*(this: var InputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc getNumBytesRemaining*(this: var InputStream): int64 {.header: juce_core, importcpp: "#.getNumBytesRemaining()".}
proc isExhausted*(this: var InputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc read*(this: var InputStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc read*(this: var InputStream, destBuffer: pointer, maxBytesToRead: uint64): int64 {.header: juce_core, importcpp: "#.read(@)".}
proc readByte*(this: var InputStream): char {.header: juce_core, importcpp: "#.readByte()".}
proc readBool*(this: var InputStream): bool {.header: juce_core, importcpp: "#.readBool()".}
proc readShort*(this: var InputStream): int16 {.header: juce_core, importcpp: "#.readShort()".}
proc readShortBigEndian*(this: var InputStream): int16 {.header: juce_core, importcpp: "#.readShortBigEndian()".}
proc readInt*(this: var InputStream): cint {.header: juce_core, importcpp: "#.readInt()".}
proc readIntBigEndian*(this: var InputStream): cint {.header: juce_core, importcpp: "#.readIntBigEndian()".}
proc readInt64*(this: var InputStream): int64 {.header: juce_core, importcpp: "#.readInt64()".}
proc readInt64BigEndian*(this: var InputStream): int64 {.header: juce_core, importcpp: "#.readInt64BigEndian()".}
proc readFloat*(this: var InputStream): cfloat {.header: juce_core, importcpp: "#.readFloat()".}
proc readFloatBigEndian*(this: var InputStream): cfloat {.header: juce_core, importcpp: "#.readFloatBigEndian()".}
proc readDouble*(this: var InputStream): float64 {.header: juce_core, importcpp: "#.readDouble()".}
proc readDoubleBigEndian*(this: var InputStream): float64 {.header: juce_core, importcpp: "#.readDoubleBigEndian()".}
proc readCompressedInt*(this: var InputStream): cint {.header: juce_core, importcpp: "#.readCompressedInt()".}
proc readNextLine*(this: var InputStream): String {.header: juce_core, importcpp: "#.readNextLine()".}
proc readString*(this: var InputStream): String {.header: juce_core, importcpp: "#.readString()".}
proc readEntireStreamAsString*(this: var InputStream): String {.header: juce_core, importcpp: "#.readEntireStreamAsString()".}
proc readIntoMemoryBlock*(this: var InputStream, destBlock: var MemoryBlock, maxNumBytesToRead: int64 = -1): uint64 {.header: juce_core, importcpp: "#.readIntoMemoryBlock(@)".}
proc getPosition*(this: var InputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var InputStream, newPosition: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc skipNextBytes*(this: var InputStream, numBytesToSkip: int64) {.header: juce_core, importcpp: "#.skipNextBytes(@)".}
proc `==`*(this: InputStream, other: InputStream): bool {.error: "juce::InputStream defines no operator==; compare a property instead".}

proc flush*(this: var OutputStream) {.header: juce_core, importcpp: "#.flush()".}
proc setPosition*(this: var OutputStream, newPosition: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc getPosition*(this: var OutputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc write*(this: var OutputStream, dataToWrite: constPointer, numberOfBytes: uint64): bool {.header: juce_core, importcpp: "#.write(@)".}
proc writeByte*(this: var OutputStream, byte: char): bool {.header: juce_core, importcpp: "#.writeByte(@)".}
proc writeBool*(this: var OutputStream, boolValue: bool): bool {.header: juce_core, importcpp: "#.writeBool(@)".}
proc writeShort*(this: var OutputStream, value: int16): bool {.header: juce_core, importcpp: "#.writeShort(@)".}
proc writeShortBigEndian*(this: var OutputStream, value: int16): bool {.header: juce_core, importcpp: "#.writeShortBigEndian(@)".}
proc writeInt*(this: var OutputStream, value: cint): bool {.header: juce_core, importcpp: "#.writeInt(@)".}
proc writeIntBigEndian*(this: var OutputStream, value: cint): bool {.header: juce_core, importcpp: "#.writeIntBigEndian(@)".}
proc writeInt64*(this: var OutputStream, value: int64): bool {.header: juce_core, importcpp: "#.writeInt64(@)".}
proc writeInt64BigEndian*(this: var OutputStream, value: int64): bool {.header: juce_core, importcpp: "#.writeInt64BigEndian(@)".}
proc writeFloat*(this: var OutputStream, value: cfloat): bool {.header: juce_core, importcpp: "#.writeFloat(@)".}
proc writeFloatBigEndian*(this: var OutputStream, value: cfloat): bool {.header: juce_core, importcpp: "#.writeFloatBigEndian(@)".}
proc writeDouble*(this: var OutputStream, value: float64): bool {.header: juce_core, importcpp: "#.writeDouble(@)".}
proc writeDoubleBigEndian*(this: var OutputStream, value: float64): bool {.header: juce_core, importcpp: "#.writeDoubleBigEndian(@)".}
proc writeRepeatedByte*(this: var OutputStream, byte: uint8, numTimesToRepeat: uint64): bool {.header: juce_core, importcpp: "#.writeRepeatedByte(@)".}
proc writeCompressedInt*(this: var OutputStream, value: cint): bool {.header: juce_core, importcpp: "#.writeCompressedInt(@)".}
proc writeString*(this: var OutputStream, text: String): bool {.header: juce_core, importcpp: "#.writeString(@)".}
proc writeText*(this: var OutputStream, text: String, asUTF16: bool, writeUTF16ByteOrderMark: bool, lineEndings: constChar): bool {.header: juce_core, importcpp: "#.writeText(@)".}
proc writeFromInputStream*(this: var OutputStream, source: var InputStream, maxNumBytesToWrite: int64): int64 {.header: juce_core, importcpp: "#.writeFromInputStream(@)".}
proc setNewLineString*(this: var OutputStream, newLineString: String) {.header: juce_core, importcpp: "#.setNewLineString(@)".}
proc getNewLineString*(this: OutputStream): String {.header: juce_core, importcpp: "#.getNewLineString()".}
proc `==`*(this: OutputStream, other: OutputStream): bool {.error: "juce::OutputStream defines no operator==; compare a property instead".}

proc makeBufferedInputStream*(sourceStream: ptr InputStream, bufferSize: cint, deleteSourceWhenDestroyed: bool): BufferedInputStream {.header: juce_core, importcpp: "juce::BufferedInputStream(@)".}
proc makeBufferedInputStream*(sourceStream: var InputStream, bufferSize: cint): BufferedInputStream {.header: juce_core, importcpp: "juce::BufferedInputStream(@)".}
proc peekByte*(this: var BufferedInputStream): char {.header: juce_core, importcpp: "#.peekByte()".}
proc getTotalLength*(this: var BufferedInputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc getPosition*(this: var BufferedInputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var BufferedInputStream, newPosition: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc read*(this: var BufferedInputStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc readString*(this: var BufferedInputStream): String {.header: juce_core, importcpp: "#.readString()".}
proc isExhausted*(this: var BufferedInputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc `==`*(this: BufferedInputStream, other: BufferedInputStream): bool {.error: "juce::BufferedInputStream defines no operator==; compare a property instead".}

proc makeMemoryInputStream*(sourceData: constPointer, sourceDataSize: uint64, keepInternalCopyOfData: bool): MemoryInputStream {.header: juce_core, importcpp: "juce::MemoryInputStream(@)".}
proc makeMemoryInputStream*(data: MemoryBlock, keepInternalCopyOfData: bool): MemoryInputStream {.header: juce_core, importcpp: "juce::MemoryInputStream(@)".}
proc makeMemoryInputStream*(blockToTake: lent MemoryBlock): MemoryInputStream {.header: juce_core, importcpp: "juce::MemoryInputStream(@)".}
proc getData*(this: MemoryInputStream): constPointer {.header: juce_core, importcpp: "#.getData()".}
proc getDataSize*(this: MemoryInputStream): uint64 {.header: juce_core, importcpp: "#.getDataSize()".}
proc getPosition*(this: var MemoryInputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var MemoryInputStream, arg1: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc getTotalLength*(this: var MemoryInputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc isExhausted*(this: var MemoryInputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc read*(this: var MemoryInputStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc skipNextBytes*(this: var MemoryInputStream, numBytesToSkip: int64) {.header: juce_core, importcpp: "#.skipNextBytes(@)".}
proc `==`*(this: MemoryInputStream, other: MemoryInputStream): bool {.error: "juce::MemoryInputStream defines no operator==; compare a property instead".}

proc makeMemoryOutputStream*(initialSize: uint64): MemoryOutputStream {.header: juce_core, importcpp: "juce::MemoryOutputStream(@)".}
proc makeMemoryOutputStream*(memoryBlockToWriteTo: var MemoryBlock, appendToExistingBlockContent: bool): MemoryOutputStream {.header: juce_core, importcpp: "juce::MemoryOutputStream(@)".}
proc makeMemoryOutputStream*(destBuffer: pointer, destBufferSize: uint64): MemoryOutputStream {.header: juce_core, importcpp: "juce::MemoryOutputStream(@)".}
proc getData*(this: MemoryOutputStream): constPointer {.header: juce_core, importcpp: "#.getData()".}
proc getDataSize*(this: MemoryOutputStream): uint64 {.header: juce_core, importcpp: "#.getDataSize()".}
proc reset*(this: var MemoryOutputStream) {.header: juce_core, importcpp: "#.reset()".}
proc preallocate*(this: var MemoryOutputStream, bytesToPreallocate: uint64) {.header: juce_core, importcpp: "#.preallocate(@)".}
proc appendUTF8Char*(this: var MemoryOutputStream, character: uint16): bool {.header: juce_core, importcpp: "#.appendUTF8Char(@)".}
proc toUTF8*(this: MemoryOutputStream): String {.header: juce_core, importcpp: "#.toUTF8()".}
proc toString*(this: MemoryOutputStream): String {.header: juce_core, importcpp: "#.toString()".}
proc getMemoryBlock*(this: MemoryOutputStream): MemoryBlock {.header: juce_core, importcpp: "#.getMemoryBlock()".}
proc flush*(this: var MemoryOutputStream) {.header: juce_core, importcpp: "#.flush()".}
proc write*(this: var MemoryOutputStream, arg1: constPointer, arg2: uint64): bool {.header: juce_core, importcpp: "#.write(@)".}
proc getPosition*(this: var MemoryOutputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var MemoryOutputStream, arg1: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc writeFromInputStream*(this: var MemoryOutputStream, arg1: var InputStream, maxNumBytesToWrite: int64): int64 {.header: juce_core, importcpp: "#.writeFromInputStream(@)".}
proc writeRepeatedByte*(this: var MemoryOutputStream, byte: uint8, numTimesToRepeat: uint64): bool {.header: juce_core, importcpp: "#.writeRepeatedByte(@)".}
proc `==`*(this: MemoryOutputStream, other: MemoryOutputStream): bool {.error: "juce::MemoryOutputStream defines no operator==; compare a property instead".}

proc makeSubregionStream*(sourceStream: ptr InputStream, startPositionInSourceStream: int64, lengthOfSourceStream: int64, deleteSourceWhenDestroyed: bool): SubregionStream {.header: juce_core, importcpp: "juce::SubregionStream(@)".}
proc getTotalLength*(this: var SubregionStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc getPosition*(this: var SubregionStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var SubregionStream, newPosition: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc read*(this: var SubregionStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc isExhausted*(this: var SubregionStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc `==`*(this: SubregionStream, other: SubregionStream): bool {.error: "juce::SubregionStream defines no operator==; compare a property instead".}

proc makeInputSource*(): InputSource {.header: juce_core, importcpp: "juce::InputSource(@)".}
proc createInputStream*(this: var InputSource): ptr InputStream {.header: juce_core, importcpp: "#.createInputStream()".}
proc createInputStreamFor*(this: var InputSource, relatedItemPath: String): ptr InputStream {.header: juce_core, importcpp: "#.createInputStreamFor(@)".}
proc hashCode*(this: InputSource): int64 {.header: juce_core, importcpp: "#.hashCode()".}
proc `==`*(this: InputSource, other: InputSource): bool {.error: "juce::InputSource defines no operator==; compare a property instead".}

proc makeFile*(): File {.header: juce_core, importcpp: "juce::File(@)".}
proc makeFile*(absolutePath: String): File {.header: juce_core, importcpp: "juce::File(@)".}
proc `File=`*(this: var File, newAbsolutePath: String): var File {.header: juce_core, importcpp: "#.operator=(@)".}
proc `File=`*(this: var File, otherFile: File): var File {.header: juce_core, importcpp: "#.operator=(@)".}
proc `File=`*(this: var File, arg1: lent File): var File {.header: juce_core, importcpp: "#.operator=(@)".}
proc exists*(this: File): bool {.header: juce_core, importcpp: "#.exists()".}
proc existsAsFile*(this: File): bool {.header: juce_core, importcpp: "#.existsAsFile()".}
proc isDirectory*(this: File): bool {.header: juce_core, importcpp: "#.isDirectory()".}
proc isRoot*(this: File): bool {.header: juce_core, importcpp: "#.isRoot()".}
proc getSize*(this: File): int64 {.header: juce_core, importcpp: "#.getSize()".}
proc getFullPathName*(this: File): String {.header: juce_core, importcpp: "#.getFullPathName()".}
proc getFileName*(this: File): String {.header: juce_core, importcpp: "#.getFileName()".}
proc getRelativePathFrom*(this: File, directoryToBeRelativeTo: File): String {.header: juce_core, importcpp: "#.getRelativePathFrom(@)".}
proc getFileExtension*(this: File): String {.header: juce_core, importcpp: "#.getFileExtension()".}
proc hasFileExtension*(this: File, extensionToTest: StringRef): bool {.header: juce_core, importcpp: "#.hasFileExtension(@)".}
proc withFileExtension*(this: File, newExtension: StringRef): File {.header: juce_core, importcpp: "#.withFileExtension(@)".}
proc getFileNameWithoutExtension*(this: File): String {.header: juce_core, importcpp: "#.getFileNameWithoutExtension()".}
proc hashCode*(this: File): cint {.header: juce_core, importcpp: "#.hashCode()".}
proc hashCode64*(this: File): int64 {.header: juce_core, importcpp: "#.hashCode64()".}
proc getChildFile*(this: File, relativeOrAbsolutePath: StringRef): File {.header: juce_core, importcpp: "#.getChildFile(@)".}
proc getSiblingFile*(this: File, siblingFileName: StringRef): File {.header: juce_core, importcpp: "#.getSiblingFile(@)".}
proc getParentDirectory*(this: File): File {.header: juce_core, importcpp: "#.getParentDirectory()".}
proc isAChildOf*(this: File, potentialParentDirectory: File): bool {.header: juce_core, importcpp: "#.isAChildOf(@)".}
proc getNonexistentChildFile*(this: File, prefix: String, suffix: String, putNumbersInBrackets: bool = true): File {.header: juce_core, importcpp: "#.getNonexistentChildFile(@)".}
proc getNonexistentSibling*(this: File, putNumbersInBrackets: bool = true): File {.header: juce_core, importcpp: "#.getNonexistentSibling(@)".}
proc `==`*(this: File, arg1: File): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: File, arg1: File): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: File, arg1: File): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>*(this: File, arg1: File): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc hasWriteAccess*(this: File): bool {.header: juce_core, importcpp: "#.hasWriteAccess()".}
proc hasReadAccess*(this: File): bool {.header: juce_core, importcpp: "#.hasReadAccess()".}
proc setReadOnly*(this: File, shouldBeReadOnly: bool, applyRecursively: bool = false): bool {.header: juce_core, importcpp: "#.setReadOnly(@)".}
proc setExecutePermission*(this: File, shouldBeExecutable: bool): bool {.header: juce_core, importcpp: "#.setExecutePermission(@)".}
proc isHidden*(this: File): bool {.header: juce_core, importcpp: "#.isHidden()".}
proc getFileIdentifier*(this: File): uint64 {.header: juce_core, importcpp: "#.getFileIdentifier()".}
proc getLastModificationTime*(this: File): Time {.header: juce_core, importcpp: "#.getLastModificationTime()".}
proc getLastAccessTime*(this: File): Time {.header: juce_core, importcpp: "#.getLastAccessTime()".}
proc getCreationTime*(this: File): Time {.header: juce_core, importcpp: "#.getCreationTime()".}
proc setLastModificationTime*(this: File, newTime: Time): bool {.header: juce_core, importcpp: "#.setLastModificationTime(@)".}
proc setLastAccessTime*(this: File, newTime: Time): bool {.header: juce_core, importcpp: "#.setLastAccessTime(@)".}
proc setCreationTime*(this: File, newTime: Time): bool {.header: juce_core, importcpp: "#.setCreationTime(@)".}
proc getVersion*(this: File): String {.header: juce_core, importcpp: "#.getVersion()".}
proc create*(this: File): Result {.header: juce_core, importcpp: "#.create()".}
proc createDirectory*(this: File): Result {.header: juce_core, importcpp: "#.createDirectory()".}
proc deleteFile*(this: File): bool {.header: juce_core, importcpp: "#.deleteFile()".}
proc deleteRecursively*(this: File, followSymlinks: bool = false): bool {.header: juce_core, importcpp: "#.deleteRecursively(@)".}
proc moveToTrash*(this: File): bool {.header: juce_core, importcpp: "#.moveToTrash()".}
proc moveFileTo*(this: File, targetLocation: File): bool {.header: juce_core, importcpp: "#.moveFileTo(@)".}
proc copyFileTo*(this: File, targetLocation: File): bool {.header: juce_core, importcpp: "#.copyFileTo(@)".}
proc replaceFileIn*(this: File, targetLocation: File): bool {.header: juce_core, importcpp: "#.replaceFileIn(@)".}
proc copyDirectoryTo*(this: File, newDirectory: File): bool {.header: juce_core, importcpp: "#.copyDirectoryTo(@)".}
proc findChildFiles*(this: File, whatToLookFor: cint, searchRecursively: bool, wildCardPattern: String, followSymlinks: FileFollowSymlinks): Array[File] {.header: juce_core, importcpp: "#.findChildFiles(@)".}
proc findChildFiles*(this: File, results: Array[File], whatToLookFor: cint, searchRecursively: bool, wildCardPattern: String, followSymlinks: FileFollowSymlinks): cint {.header: juce_core, importcpp: "#.findChildFiles(@)".}
proc getNumberOfChildFiles*(this: File, whatToLookFor: cint, wildCardPattern: String): cint {.header: juce_core, importcpp: "#.getNumberOfChildFiles(@)".}
proc containsSubDirectories*(this: File): bool {.header: juce_core, importcpp: "#.containsSubDirectories()".}
proc createInputStream*(this: File): UniquePtr[FileInputStream] {.header: juce_core, importcpp: "#.createInputStream()".}
proc createOutputStream*(this: File, bufferSize: uint64 = 0x8000): UniquePtr[FileOutputStream] {.header: juce_core, importcpp: "#.createOutputStream(@)".}
proc loadFileAsData*(this: File, result: var MemoryBlock): bool {.header: juce_core, importcpp: "#.loadFileAsData(@)".}
proc loadFileAsString*(this: File): String {.header: juce_core, importcpp: "#.loadFileAsString()".}
proc readLines*(this: File, destLines: var StringArray) {.header: juce_core, importcpp: "#.readLines(@)".}
proc appendData*(this: File, dataToAppend: constPointer, numberOfBytes: uint64): bool {.header: juce_core, importcpp: "#.appendData(@)".}
proc replaceWithData*(this: File, dataToWrite: constPointer, numberOfBytes: uint64): bool {.header: juce_core, importcpp: "#.replaceWithData(@)".}
proc appendText*(this: File, textToAppend: String, asUnicode: bool = false, writeUnicodeHeaderBytes: bool = false, lineEndings: constChar = "\r\n"): bool {.header: juce_core, importcpp: "#.appendText(@)".}
proc replaceWithText*(this: File, textToWrite: String, asUnicode: bool = false, writeUnicodeHeaderBytes: bool = false, lineEndings: constChar = "\r\n"): bool {.header: juce_core, importcpp: "#.replaceWithText(@)".}
proc hasIdenticalContentTo*(this: File, other: File): bool {.header: juce_core, importcpp: "#.hasIdenticalContentTo(@)".}
proc getVolumeLabel*(this: File): String {.header: juce_core, importcpp: "#.getVolumeLabel()".}
proc getVolumeSerialNumber*(this: File): cint {.header: juce_core, importcpp: "#.getVolumeSerialNumber()".}
proc getBytesFreeOnVolume*(this: File): int64 {.header: juce_core, importcpp: "#.getBytesFreeOnVolume()".}
proc getVolumeTotalSize*(this: File): int64 {.header: juce_core, importcpp: "#.getVolumeTotalSize()".}
proc isOnCDRomDrive*(this: File): bool {.header: juce_core, importcpp: "#.isOnCDRomDrive()".}
proc isOnHardDisk*(this: File): bool {.header: juce_core, importcpp: "#.isOnHardDisk()".}
proc isOnRemovableDrive*(this: File): bool {.header: juce_core, importcpp: "#.isOnRemovableDrive()".}
proc startAsProcess*(this: File, parameters: String): bool {.header: juce_core, importcpp: "#.startAsProcess(@)".}
proc revealToUser*(this: File) {.header: juce_core, importcpp: "#.revealToUser()".}
proc setAsCurrentWorkingDirectory*(this: File): bool {.header: juce_core, importcpp: "#.setAsCurrentWorkingDirectory()".}
proc createSymbolicLink*(this: File, linkFileToCreate: File, overwriteExisting: bool): bool {.header: juce_core, importcpp: "#.createSymbolicLink(@)".}
proc isSymbolicLink*(this: File): bool {.header: juce_core, importcpp: "#.isSymbolicLink()".}
proc getLinkedTarget*(this: File): File {.header: juce_core, importcpp: "#.getLinkedTarget()".}
proc getNativeLinkedTarget*(this: File): String {.header: juce_core, importcpp: "#.getNativeLinkedTarget()".}
# proc getMacOSType*(this: File): uint32 {.header: juce_core, importcpp: "#.getMacOSType()".}
proc isBundle*(this: File): bool {.header: juce_core, importcpp: "#.isBundle()".}
proc addToDock*(this: File) {.header: juce_core, importcpp: "#.addToDock()".}

proc makeDirectoryIterator*(directory: File, recursive: bool, pattern: String, `type`: cint, follow: FileFollowSymlinks): DirectoryIterator {.header: juce_core, importcpp: "juce::DirectoryIterator(@)".}
proc next*(this: var DirectoryIterator): bool {.header: juce_core, importcpp: "#.next()".}
proc next*(this: var DirectoryIterator, isDirectory: ptr bool, isHidden: ptr bool, fileSize: ptr int64, modTime: ptr Time, creationTime: ptr Time, isReadOnly: ptr bool): bool {.header: juce_core, importcpp: "#.next(@)".}
proc getFile*(this: DirectoryIterator): File {.header: juce_core, importcpp: "#.getFile()".}
proc getEstimatedProgress*(this: DirectoryIterator): cfloat {.header: juce_core, importcpp: "#.getEstimatedProgress()".}
proc `==`*(this: DirectoryIterator, other: DirectoryIterator): bool {.error: "juce::DirectoryIterator defines no operator==; compare a property instead".}

proc getFile*(this: DirectoryEntry): File {.header: juce_core, importcpp: "#.getFile()".}
proc getModificationTime*(this: DirectoryEntry): Time {.header: juce_core, importcpp: "#.getModificationTime()".}
proc getCreationTime*(this: DirectoryEntry): Time {.header: juce_core, importcpp: "#.getCreationTime()".}
proc getFileSize*(this: DirectoryEntry): int64 {.header: juce_core, importcpp: "#.getFileSize()".}
proc isDirectory*(this: DirectoryEntry): bool {.header: juce_core, importcpp: "#.isDirectory()".}
proc isHidden*(this: DirectoryEntry): bool {.header: juce_core, importcpp: "#.isHidden()".}
proc isReadOnly*(this: DirectoryEntry): bool {.header: juce_core, importcpp: "#.isReadOnly()".}
proc getEstimatedProgress*(this: DirectoryEntry): cfloat {.header: juce_core, importcpp: "#.getEstimatedProgress()".}
proc `==`*(this: DirectoryEntry, other: DirectoryEntry): bool {.error: "juce::DirectoryEntry defines no operator==; compare a property instead".}

proc makeRangedDirectoryIterator*(): RangedDirectoryIterator {.header: juce_core, importcpp: "juce::RangedDirectoryIterator(@)".}
proc makeRangedDirectoryIterator*(directory: File, isRecursive: bool, wildCard: String, whatToLookFor: cint, followSymlinks: FileFollowSymlinks): RangedDirectoryIterator {.header: juce_core, importcpp: "juce::RangedDirectoryIterator(@)".}
proc `==`*(this: RangedDirectoryIterator, other: RangedDirectoryIterator): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: RangedDirectoryIterator, other: RangedDirectoryIterator): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `*`*(this: RangedDirectoryIterator): DirectoryEntry {.header: juce_core, importcpp: "#.operator*()".}
# proc operator->*(this: RangedDirectoryIterator): ptr DirectoryEntry {.header: juce_core, importcpp: "#.operator->()".}
proc `inc`*(this: var RangedDirectoryIterator): var RangedDirectoryIterator {.header: juce_core, importcpp: "#.operator++()".}
proc `inc`*(this: var RangedDirectoryIterator, arg1: cint): DirectoryEntry {.header: juce_core, importcpp: "#.operator++(@)".}

proc makeFileInputStream*(fileToRead: File): FileInputStream {.header: juce_core, importcpp: "juce::FileInputStream(@)".}
proc getFile*(this: FileInputStream): File {.header: juce_core, importcpp: "#.getFile()".}
proc getStatus*(this: FileInputStream): Result {.header: juce_core, importcpp: "#.getStatus()".}
proc failedToOpen*(this: FileInputStream): bool {.header: juce_core, importcpp: "#.failedToOpen()".}
proc openedOk*(this: FileInputStream): bool {.header: juce_core, importcpp: "#.openedOk()".}
proc getTotalLength*(this: var FileInputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc read*(this: var FileInputStream, arg1: pointer, arg2: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc isExhausted*(this: var FileInputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc getPosition*(this: var FileInputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var FileInputStream, arg1: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc `==`*(this: FileInputStream, other: FileInputStream): bool {.error: "juce::FileInputStream defines no operator==; compare a property instead".}

proc makeFileOutputStream*(fileToWriteTo: File, bufferSizeToUse: uint64): FileOutputStream {.header: juce_core, importcpp: "juce::FileOutputStream(@)".}
proc getFile*(this: FileOutputStream): File {.header: juce_core, importcpp: "#.getFile()".}
proc getStatus*(this: FileOutputStream): Result {.header: juce_core, importcpp: "#.getStatus()".}
proc failedToOpen*(this: FileOutputStream): bool {.header: juce_core, importcpp: "#.failedToOpen()".}
proc openedOk*(this: FileOutputStream): bool {.header: juce_core, importcpp: "#.openedOk()".}
proc truncate*(this: var FileOutputStream): Result {.header: juce_core, importcpp: "#.truncate()".}
proc flush*(this: var FileOutputStream) {.header: juce_core, importcpp: "#.flush()".}
proc getPosition*(this: var FileOutputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var FileOutputStream, arg1: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc write*(this: var FileOutputStream, arg1: constPointer, arg2: uint64): bool {.header: juce_core, importcpp: "#.write(@)".}
proc writeRepeatedByte*(this: var FileOutputStream, byte: uint8, numTimesToRepeat: uint64): bool {.header: juce_core, importcpp: "#.writeRepeatedByte(@)".}
proc `==`*(this: FileOutputStream, other: FileOutputStream): bool {.error: "juce::FileOutputStream defines no operator==; compare a property instead".}

proc makeFileSearchPath*(): FileSearchPath {.header: juce_core, importcpp: "juce::FileSearchPath(@)".}
proc makeFileSearchPath*(path: String): FileSearchPath {.header: juce_core, importcpp: "juce::FileSearchPath(@)".}
proc `FileSearchPath=`*(this: var FileSearchPath, arg1: FileSearchPath): var FileSearchPath {.header: juce_core, importcpp: "#.operator=(@)".}
proc `FileSearchPath=`*(this: var FileSearchPath, path: String): var FileSearchPath {.header: juce_core, importcpp: "#.operator=(@)".}
proc getNumPaths*(this: FileSearchPath): cint {.header: juce_core, importcpp: "#.getNumPaths()".}
proc `[]`*(this: FileSearchPath, index: cint): File {.header: juce_core, importcpp: "#.operator[](@)".}
proc getRawString*(this: FileSearchPath, index: cint): String {.header: juce_core, importcpp: "#.getRawString(@)".}
proc toString*(this: FileSearchPath): String {.header: juce_core, importcpp: "#.toString()".}
proc toStringWithSeparator*(this: FileSearchPath, separator: StringRef): String {.header: juce_core, importcpp: "#.toStringWithSeparator(@)".}
proc add*(this: var FileSearchPath, directoryToAdd: File, insertIndex: cint = -1) {.header: juce_core, importcpp: "#.add(@)".}
proc addIfNotAlreadyThere*(this: var FileSearchPath, directoryToAdd: File): bool {.header: juce_core, importcpp: "#.addIfNotAlreadyThere(@)".}
proc remove*(this: var FileSearchPath, indexToRemove: cint) {.header: juce_core, importcpp: "#.remove(@)".}
proc addPath*(this: var FileSearchPath, arg1: FileSearchPath) {.header: juce_core, importcpp: "#.addPath(@)".}
proc removeRedundantPaths*(this: var FileSearchPath) {.header: juce_core, importcpp: "#.removeRedundantPaths()".}
proc removeNonExistentPaths*(this: var FileSearchPath) {.header: juce_core, importcpp: "#.removeNonExistentPaths()".}
proc findChildFiles*(this: FileSearchPath, whatToLookFor: cint, searchRecursively: bool, wildCardPattern: String): Array[File] {.header: juce_core, importcpp: "#.findChildFiles(@)".}
proc findChildFiles*(this: FileSearchPath, results: Array[File], whatToLookFor: cint, searchRecursively: bool, wildCardPattern: String): cint {.header: juce_core, importcpp: "#.findChildFiles(@)".}
proc isFileInPath*(this: FileSearchPath, fileToCheck: File, checkRecursively: bool): bool {.header: juce_core, importcpp: "#.isFileInPath(@)".}
proc `==`*(this: FileSearchPath, other: FileSearchPath): bool {.error: "juce::FileSearchPath defines no operator==; compare a property instead".}

proc makeMemoryMappedFile*(file: File, mode: MemoryMappedFileAccessMode, exclusive: bool): MemoryMappedFile {.header: juce_core, importcpp: "juce::MemoryMappedFile(@)".}
proc makeMemoryMappedFile*(file: File, fileRange: Range[int64], mode: MemoryMappedFileAccessMode, exclusive: bool): MemoryMappedFile {.header: juce_core, importcpp: "juce::MemoryMappedFile(@)".}
proc getData*(this: MemoryMappedFile): pointer {.header: juce_core, importcpp: "#.getData()".}
proc getSize*(this: MemoryMappedFile): uint64 {.header: juce_core, importcpp: "#.getSize()".}
# proc getRange*(this: MemoryMappedFile): Range[int64] {.header: juce_core, importcpp: "#.getRange()".}
proc `==`*(this: MemoryMappedFile, other: MemoryMappedFile): bool {.error: "juce::MemoryMappedFile defines no operator==; compare a property instead".}

proc makeTemporaryFile*(): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc makeTemporaryFile*(suffix: String): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc makeTemporaryFile*(suffix: String, optionFlags: cint): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc makeTemporaryFile*(targetFile: File): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc makeTemporaryFile*(targetFile: File, optionFlags: cint): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc makeTemporaryFile*(targetFile: File, temporaryFile: File): TemporaryFile {.header: juce_core, importcpp: "juce::TemporaryFile(@)".}
proc getFile*(this: TemporaryFile): File {.header: juce_core, importcpp: "#.getFile()".}
proc getTargetFile*(this: TemporaryFile): File {.header: juce_core, importcpp: "#.getTargetFile()".}
proc overwriteTargetFileWithTemporary*(this: TemporaryFile): bool {.header: juce_core, importcpp: "#.overwriteTargetFileWithTemporary()".}
proc deleteTemporaryFile*(this: TemporaryFile): bool {.header: juce_core, importcpp: "#.deleteTemporaryFile()".}
proc `==`*(this: TemporaryFile, other: TemporaryFile): bool {.error: "juce::TemporaryFile defines no operator==; compare a property instead".}

proc makeFileFilter*(filterDescription: String): FileFilter {.header: juce_core, importcpp: "juce::FileFilter(@)".}
proc getDescription*(this: FileFilter): String {.header: juce_core, importcpp: "#.getDescription()".}
proc isFileSuitable*(this: FileFilter, file: File): bool {.header: juce_core, importcpp: "#.isFileSuitable(@)".}
proc isDirectorySuitable*(this: FileFilter, file: File): bool {.header: juce_core, importcpp: "#.isDirectorySuitable(@)".}
proc `==`*(this: FileFilter, other: FileFilter): bool {.error: "juce::FileFilter defines no operator==; compare a property instead".}

proc makeWildcardFileFilter*(fileWildcardPatterns: String, directoryWildcardPatterns: String, filterDescription: String): WildcardFileFilter {.header: juce_core, importcpp: "juce::WildcardFileFilter(@)".}
proc isFileSuitable*(this: WildcardFileFilter, file: File): bool {.header: juce_core, importcpp: "#.isFileSuitable(@)".}
proc isDirectorySuitable*(this: WildcardFileFilter, file: File): bool {.header: juce_core, importcpp: "#.isDirectorySuitable(@)".}
proc `==`*(this: WildcardFileFilter, other: WildcardFileFilter): bool {.error: "juce::WildcardFileFilter defines no operator==; compare a property instead".}

proc makeFileInputSource*(file: File, useFileTimeInHashGeneration: bool): FileInputSource {.header: juce_core, importcpp: "juce::FileInputSource(@)".}
proc createInputStream*(this: var FileInputSource): ptr InputStream {.header: juce_core, importcpp: "#.createInputStream()".}
proc createInputStreamFor*(this: var FileInputSource, relatedItemPath: String): ptr InputStream {.header: juce_core, importcpp: "#.createInputStreamFor(@)".}
proc hashCode*(this: FileInputSource): int64 {.header: juce_core, importcpp: "#.hashCode()".}
proc `==`*(this: FileInputSource, other: FileInputSource): bool {.error: "juce::FileInputSource defines no operator==; compare a property instead".}

proc makeFileLogger*(fileToWriteTo: File, welcomeMessage: String, maxInitialFileSizeBytes: int64): FileLogger {.header: juce_core, importcpp: "juce::FileLogger(@)".}
proc getLogFile*(this: FileLogger): File {.header: juce_core, importcpp: "#.getLogFile()".}
proc logMessage*(this: var FileLogger, arg1: String) {.header: juce_core, importcpp: "#.logMessage(@)".}
proc `==`*(this: FileLogger, other: FileLogger): bool {.error: "juce::FileLogger defines no operator==; compare a property instead".}

proc makeJSONUtils*(): JSONUtils {.header: juce_core, importcpp: "juce::JSONUtils(@)".}
proc `==`*(this: JSONUtils, other: JSONUtils): bool {.error: "juce::JSONUtils defines no operator==; compare a property instead".}

proc `==`*(this: SerialisationTraits, other: SerialisationTraits): bool {.error: "juce::SerialisationTraits defines no operator==; compare a property instead".}

proc withExplicitVersion*(this: ToVarOptions, x: CppOptional[cint]): ToVarOptions {.header: juce_core, importcpp: "#.withExplicitVersion(@)".}
proc withVersionIncluded*(this: ToVarOptions, x: bool): ToVarOptions {.header: juce_core, importcpp: "#.withVersionIncluded(@)".}
proc getExplicitVersion*(this: ToVarOptions): CppOptional[CppOptional[cint]] {.header: juce_core, importcpp: "#.getExplicitVersion()".}
proc getVersionIncluded*(this: ToVarOptions): bool {.header: juce_core, importcpp: "#.getVersionIncluded()".}
proc `==`*(this: ToVarOptions, other: ToVarOptions): bool {.error: "juce::ToVarOptions defines no operator==; compare a property instead".}

proc `==`*(this: ToVar, other: ToVar): bool {.error: "juce::ToVar defines no operator==; compare a property instead".}

proc `==`*(this: FromVar, other: FromVar): bool {.error: "juce::FromVar defines no operator==; compare a property instead".}

proc `==`*(this: VariantConverter, other: VariantConverter): bool {.error: "juce::VariantConverter defines no operator==; compare a property instead".}

proc makeBigInteger*(): BigInteger {.header: juce_core, importcpp: "juce::BigInteger(@)".}
proc makeBigInteger*(value: uint32): BigInteger {.header: juce_core, importcpp: "juce::BigInteger(@)".}
proc makeBigInteger*(value: cint): BigInteger {.header: juce_core, importcpp: "juce::BigInteger(@)".}
proc makeBigInteger*(value: int64): BigInteger {.header: juce_core, importcpp: "juce::BigInteger(@)".}
proc `BigInteger=`*(this: var BigInteger, arg1: lent BigInteger): var BigInteger {.header: juce_core, importcpp: "#.operator=(@)".}
proc `BigInteger=`*(this: var BigInteger, arg1: BigInteger): var BigInteger {.header: juce_core, importcpp: "#.operator=(@)".}
proc swapWith*(this: var BigInteger, arg1: var BigInteger) {.header: juce_core, importcpp: "#.swapWith(@)".}
proc `[]`*(this: BigInteger, bit: cint): bool {.header: juce_core, importcpp: "#.operator[](@)".}
proc isZero*(this: BigInteger): bool {.header: juce_core, importcpp: "#.isZero()".}
proc isOne*(this: BigInteger): bool {.header: juce_core, importcpp: "#.isOne()".}
proc toInteger*(this: BigInteger): cint {.header: juce_core, importcpp: "#.toInteger()".}
proc toInt64*(this: BigInteger): int64 {.header: juce_core, importcpp: "#.toInt64()".}
proc clear*(this: var BigInteger): var BigInteger {.header: juce_core, importcpp: "#.clear()".}
proc clearBit*(this: var BigInteger, bitNumber: cint): var BigInteger {.header: juce_core, importcpp: "#.clearBit(@)".}
proc setBit*(this: var BigInteger, bitNumber: cint): var BigInteger {.header: juce_core, importcpp: "#.setBit(@)".}
proc setBit*(this: var BigInteger, bitNumber: cint, shouldBeSet: bool): var BigInteger {.header: juce_core, importcpp: "#.setBit(@)".}
proc setRange*(this: var BigInteger, startBit: cint, numBits: cint, shouldBeSet: bool): var BigInteger {.header: juce_core, importcpp: "#.setRange(@)".}
proc insertBit*(this: var BigInteger, bitNumber: cint, shouldBeSet: bool): var BigInteger {.header: juce_core, importcpp: "#.insertBit(@)".}
proc getBitRange*(this: BigInteger, startBit: cint, numBits: cint): BigInteger {.header: juce_core, importcpp: "#.getBitRange(@)".}
proc getBitRangeAsInt*(this: BigInteger, startBit: cint, numBits: cint): uint32 {.header: juce_core, importcpp: "#.getBitRangeAsInt(@)".}
proc setBitRangeAsInt*(this: var BigInteger, startBit: cint, numBits: cint, valueToSet: uint32): var BigInteger {.header: juce_core, importcpp: "#.setBitRangeAsInt(@)".}
proc shiftBits*(this: var BigInteger, howManyBitsLeft: cint, startBit: cint): var BigInteger {.header: juce_core, importcpp: "#.shiftBits(@)".}
proc countNumberOfSetBits*(this: BigInteger): cint {.header: juce_core, importcpp: "#.countNumberOfSetBits()".}
proc findNextSetBit*(this: BigInteger, startIndex: cint): cint {.header: juce_core, importcpp: "#.findNextSetBit(@)".}
proc findNextClearBit*(this: BigInteger, startIndex: cint): cint {.header: juce_core, importcpp: "#.findNextClearBit(@)".}
proc getHighestBit*(this: BigInteger): cint {.header: juce_core, importcpp: "#.getHighestBit()".}
proc isNegative*(this: BigInteger): bool {.header: juce_core, importcpp: "#.isNegative()".}
proc setNegative*(this: var BigInteger, shouldBeNegative: bool) {.header: juce_core, importcpp: "#.setNegative(@)".}
proc negate*(this: var BigInteger) {.header: juce_core, importcpp: "#.negate()".}
proc `+=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `*=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator*=(@)".}
proc `/=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator/=(@)".}
proc `|=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator|=(@)".}
proc `&=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator&=(@)".}
proc `^=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator^=(@)".}
proc `%=`*(this: var BigInteger, arg1: BigInteger) {.header: juce_core, importcpp: "#.operator%=(@)".}
proc `<<=`*(this: var BigInteger, numBitsToShift: cint) {.header: juce_core, importcpp: "#.operator<<=(@)".}
proc `>>=`*(this: var BigInteger, numBitsToShift: cint) {.header: juce_core, importcpp: "#.operator>>=(@)".}
proc `inc`*(this: var BigInteger): var BigInteger {.header: juce_core, importcpp: "#.operator++()".}
proc `dec`*(this: var BigInteger): var BigInteger {.header: juce_core, importcpp: "#.operator--()".}
proc `inc`*(this: var BigInteger, arg1: cint): BigInteger {.header: juce_core, importcpp: "#.operator++(@)".}
proc `dec`*(this: var BigInteger, arg1: cint): BigInteger {.header: juce_core, importcpp: "#.operator--(@)".}
proc `-`*(this: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator-()".}
proc `+`*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator-(@)".}
proc `*`*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator*(@)".}
proc `/`*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator/(@)".}
# proc operator|*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator|(@)".}
# proc operator&*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator&(@)".}
# proc operator^*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator^(@)".}
# proc operator%*(this: BigInteger, arg1: BigInteger): BigInteger {.header: juce_core, importcpp: "#.operator%(@)".}
# proc operator<<*(this: BigInteger, numBitsToShift: cint): BigInteger {.header: juce_core, importcpp: "#.operator<<(@)".}
# proc operator>>*(this: BigInteger, numBitsToShift: cint): BigInteger {.header: juce_core, importcpp: "#.operator>>(@)".}
proc `==`*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator<(@)".}
proc `<=`*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
# proc operator>*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator>(@)".}
# proc operator>=*(this: BigInteger, arg1: BigInteger): bool {.header: juce_core, importcpp: "#.operator>=(@)".}
proc compare*(this: BigInteger, other: BigInteger): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc compareAbsolute*(this: BigInteger, other: BigInteger): cint {.header: juce_core, importcpp: "#.compareAbsolute(@)".}
proc divideBy*(this: var BigInteger, divisor: BigInteger, remainder: var BigInteger) {.header: juce_core, importcpp: "#.divideBy(@)".}
proc findGreatestCommonDivisor*(this: BigInteger, other: BigInteger): BigInteger {.header: juce_core, importcpp: "#.findGreatestCommonDivisor(@)".}
proc exponentModulo*(this: var BigInteger, exponent: BigInteger, modulus: BigInteger) {.header: juce_core, importcpp: "#.exponentModulo(@)".}
proc inverseModulo*(this: var BigInteger, modulus: BigInteger) {.header: juce_core, importcpp: "#.inverseModulo(@)".}
proc montgomeryMultiplication*(this: var BigInteger, other: BigInteger, modulus: BigInteger, modulusp: BigInteger, k: cint) {.header: juce_core, importcpp: "#.montgomeryMultiplication(@)".}
proc extendedEuclidean*(this: var BigInteger, a: BigInteger, b: BigInteger, xOut: var BigInteger, yOut: var BigInteger) {.header: juce_core, importcpp: "#.extendedEuclidean(@)".}
proc toString*(this: BigInteger, base: cint, minimumNumCharacters: cint = 1): String {.header: juce_core, importcpp: "#.toString(@)".}
proc parseString*(this: var BigInteger, text: StringRef, base: cint) {.header: juce_core, importcpp: "#.parseString(@)".}
proc toMemoryBlock*(this: BigInteger): MemoryBlock {.header: juce_core, importcpp: "#.toMemoryBlock()".}
proc loadFromMemoryBlock*(this: var BigInteger, data: MemoryBlock) {.header: juce_core, importcpp: "#.loadFromMemoryBlock(@)".}

proc makeExpression*(): Expression {.header: juce_core, importcpp: "juce::Expression(@)".}
proc makeExpression*(constant: float64): Expression {.header: juce_core, importcpp: "juce::Expression(@)".}
proc makeExpression*(stringToParse: String, parseError: var String): Expression {.header: juce_core, importcpp: "juce::Expression(@)".}
proc `Expression=`*(this: var Expression, arg1: Expression): var Expression {.header: juce_core, importcpp: "#.operator=(@)".}
proc `Expression=`*(this: var Expression, arg1: lent Expression): var Expression {.header: juce_core, importcpp: "#.operator=(@)".}
proc toString*(this: Expression): String {.header: juce_core, importcpp: "#.toString()".}
proc `+`*(this: Expression, arg1: Expression): Expression {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: Expression, arg1: Expression): Expression {.header: juce_core, importcpp: "#.operator-(@)".}
proc `*`*(this: Expression, arg1: Expression): Expression {.header: juce_core, importcpp: "#.operator*(@)".}
proc `/`*(this: Expression, arg1: Expression): Expression {.header: juce_core, importcpp: "#.operator/(@)".}
proc `-`*(this: Expression): Expression {.header: juce_core, importcpp: "#.operator-()".}
proc evaluate*(this: Expression): float64 {.header: juce_core, importcpp: "#.evaluate()".}
proc evaluate*(this: Expression, scope: ExpressionScope): float64 {.header: juce_core, importcpp: "#.evaluate(@)".}
proc evaluate*(this: Expression, scope: ExpressionScope, evaluationError: var String): float64 {.header: juce_core, importcpp: "#.evaluate(@)".}
proc adjustedToGiveNewResult*(this: Expression, targetValue: float64, scope: ExpressionScope): Expression {.header: juce_core, importcpp: "#.adjustedToGiveNewResult(@)".}
proc withRenamedSymbol*(this: Expression, oldSymbol: ExpressionSymbol, newName: String, scope: ExpressionScope): Expression {.header: juce_core, importcpp: "#.withRenamedSymbol(@)".}
proc referencesSymbol*(this: Expression, symbol: ExpressionSymbol, scope: ExpressionScope): bool {.header: juce_core, importcpp: "#.referencesSymbol(@)".}
proc usesAnySymbols*(this: Expression): bool {.header: juce_core, importcpp: "#.usesAnySymbols()".}
proc findReferencedSymbols*(this: Expression, results: Array[ExpressionSymbol], scope: ExpressionScope) {.header: juce_core, importcpp: "#.findReferencedSymbols(@)".}
# proc getType*(this: Expression): ExpressionType {.header: juce_core, importcpp: "#.getType()".}
proc getSymbolOrFunction*(this: Expression): String {.header: juce_core, importcpp: "#.getSymbolOrFunction()".}
proc getNumInputs*(this: Expression): cint {.header: juce_core, importcpp: "#.getNumInputs()".}
proc getInput*(this: Expression, index: cint): Expression {.header: juce_core, importcpp: "#.getInput(@)".}
proc `==`*(this: Expression, other: Expression): bool {.error: "juce::Expression defines no operator==; compare a property instead".}

proc makeRandom*(seedValue: int64): Random {.header: juce_core, importcpp: "juce::Random(@)".}
proc makeRandom*(): Random {.header: juce_core, importcpp: "juce::Random(@)".}
# proc nextInt*(this: var Random): cint {.header: juce_core, importcpp: "#.nextInt()".}
# proc nextInt*(this: var Random, maxValue: cint): cint {.header: juce_core, importcpp: "#.nextInt(@)".}
# proc nextInt*(this: var Random, range: Range[cint]): cint {.header: juce_core, importcpp: "#.nextInt(@)".}
proc nextInt64*(this: var Random): int64 {.header: juce_core, importcpp: "#.nextInt64()".}
proc nextFloat*(this: var Random): cfloat {.header: juce_core, importcpp: "#.nextFloat()".}
proc nextDouble*(this: var Random): float64 {.header: juce_core, importcpp: "#.nextDouble()".}
proc nextBool*(this: var Random): bool {.header: juce_core, importcpp: "#.nextBool()".}
proc nextLargeNumber*(this: var Random, maximumValue: BigInteger): BigInteger {.header: juce_core, importcpp: "#.nextLargeNumber(@)".}
proc fillBitsRandomly*(this: var Random, bufferToFill: pointer, sizeInBytes: uint64) {.header: juce_core, importcpp: "#.fillBitsRandomly(@)".}
proc fillBitsRandomly*(this: var Random, arrayToChange: var BigInteger, startBit: cint, numBits: cint) {.header: juce_core, importcpp: "#.fillBitsRandomly(@)".}
proc setSeed*(this: var Random, newSeed: int64) {.header: juce_core, importcpp: "#.setSeed(@)".}
proc getSeed*(this: Random): int64 {.header: juce_core, importcpp: "#.getSeed()".}
proc combineSeed*(this: var Random, seedValue: int64) {.header: juce_core, importcpp: "#.combineSeed(@)".}
proc setSeedRandomly*(this: var Random) {.header: juce_core, importcpp: "#.setSeedRandomly()".}
proc `==`*(this: Random, other: Random): bool {.error: "juce::Random defines no operator==; compare a property instead".}

proc `==`*(this: RuntimePermissions, other: RuntimePermissions): bool {.error: "juce::RuntimePermissions defines no operator==; compare a property instead".}

proc makeChildProcess*(): ChildProcess {.header: juce_core, importcpp: "juce::ChildProcess(@)".}
proc start*(this: var ChildProcess, command: String, streamFlags: cint): bool {.header: juce_core, importcpp: "#.start(@)".}
proc start*(this: var ChildProcess, arguments: StringArray, streamFlags: cint): bool {.header: juce_core, importcpp: "#.start(@)".}
proc isRunning*(this: ChildProcess): bool {.header: juce_core, importcpp: "#.isRunning()".}
proc readProcessOutput*(this: var ChildProcess, destBuffer: pointer, numBytesToRead: cint): cint {.header: juce_core, importcpp: "#.readProcessOutput(@)".}
proc readAllProcessOutput*(this: var ChildProcess): String {.header: juce_core, importcpp: "#.readAllProcessOutput()".}
proc waitForProcessToFinish*(this: ChildProcess, timeoutMs: cint): bool {.header: juce_core, importcpp: "#.waitForProcessToFinish(@)".}
proc getExitCode*(this: ChildProcess): uint32 {.header: juce_core, importcpp: "#.getExitCode()".}
proc kill*(this: var ChildProcess): bool {.header: juce_core, importcpp: "#.kill()".}
proc `==`*(this: ChildProcess, other: ChildProcess): bool {.error: "juce::ChildProcess defines no operator==; compare a property instead".}

proc makeDynamicLibrary*(): DynamicLibrary {.header: juce_core, importcpp: "juce::DynamicLibrary(@)".}
proc makeDynamicLibrary*(name: String): DynamicLibrary {.header: juce_core, importcpp: "juce::DynamicLibrary(@)".}
proc open*(this: var DynamicLibrary, name: String): bool {.header: juce_core, importcpp: "#.open(@)".}
proc close*(this: var DynamicLibrary) {.header: juce_core, importcpp: "#.close()".}
proc getFunction*(this: var DynamicLibrary, functionName: String): pointer {.header: juce_core, importcpp: "#.getFunction(@)".}
proc isOpen*(this: DynamicLibrary): bool {.header: juce_core, importcpp: "#.isOpen()".}
proc getNativeHandle*(this: DynamicLibrary): pointer {.header: juce_core, importcpp: "#.getNativeHandle()".}
proc `==`*(this: DynamicLibrary, other: DynamicLibrary): bool {.error: "juce::DynamicLibrary defines no operator==; compare a property instead".}

proc makeInterProcessLock*(name: String): InterProcessLock {.header: juce_core, importcpp: "juce::InterProcessLock(@)".}
proc enter*(this: var InterProcessLock, timeOutMillisecs: cint = -1): bool {.header: juce_core, importcpp: "#.enter(@)".}
proc exit*(this: var InterProcessLock) {.header: juce_core, importcpp: "#.exit()".}
proc `==`*(this: InterProcessLock, other: InterProcessLock): bool {.error: "juce::InterProcessLock defines no operator==; compare a property instead".}

proc `==`*(this: Process, other: Process): bool {.error: "juce::Process defines no operator==; compare a property instead".}

proc makeSpinLock*(): SpinLock {.header: juce_core, importcpp: "juce::SpinLock(@)".}
proc enter*(this: SpinLock) {.header: juce_core, importcpp: "#.enter()".}
proc tryEnter*(this: SpinLock): bool {.header: juce_core, importcpp: "#.tryEnter()".}
proc exit*(this: SpinLock) {.header: juce_core, importcpp: "#.exit()".}
proc `==`*(this: SpinLock, other: SpinLock): bool {.error: "juce::SpinLock defines no operator==; compare a property instead".}

proc makeWaitableEvent*(manualReset: bool): WaitableEvent {.header: juce_core, importcpp: "juce::WaitableEvent(@)".}
proc wait*(this: WaitableEvent, timeOutMilliseconds: float64 = -1.0): bool {.header: juce_core, importcpp: "#.wait(@)".}
proc signal*(this: WaitableEvent) {.header: juce_core, importcpp: "#.signal()".}
proc reset*(this: WaitableEvent) {.header: juce_core, importcpp: "#.reset()".}
proc `==`*(this: WaitableEvent, other: WaitableEvent): bool {.error: "juce::WaitableEvent defines no operator==; compare a property instead".}

proc makeThread*(threadName: String, threadStackSize: uint64): Thread {.header: juce_core, importcpp: "juce::Thread(@)".}
proc run*(this: var Thread) {.header: juce_core, importcpp: "#.run()".}
proc startThread*(this: var Thread): bool {.header: juce_core, importcpp: "#.startThread()".}
proc startThread*(this: var Thread, newPriority: ThreadPriority): bool {.header: juce_core, importcpp: "#.startThread(@)".}
proc startRealtimeThread*(this: var Thread, options: ThreadRealtimeOptions): bool {.header: juce_core, importcpp: "#.startRealtimeThread(@)".}
proc stopThread*(this: var Thread, timeOutMilliseconds: cint): bool {.header: juce_core, importcpp: "#.stopThread(@)".}
proc isThreadRunning*(this: Thread): bool {.header: juce_core, importcpp: "#.isThreadRunning()".}
proc signalThreadShouldExit*(this: var Thread) {.header: juce_core, importcpp: "#.signalThreadShouldExit()".}
proc threadShouldExit*(this: Thread): bool {.header: juce_core, importcpp: "#.threadShouldExit()".}
proc waitForThreadToExit*(this: Thread, timeOutMilliseconds: cint): bool {.header: juce_core, importcpp: "#.waitForThreadToExit(@)".}
proc addListener*(this: var Thread, arg1: ptr ThreadListener) {.header: juce_core, importcpp: "#.addListener(@)".}
proc removeListener*(this: var Thread, arg1: ptr ThreadListener) {.header: juce_core, importcpp: "#.removeListener(@)".}
proc isRealtime*(this: Thread): bool {.header: juce_core, importcpp: "#.isRealtime()".}
proc setAffinityMask*(this: var Thread, affinityMask: uint32) {.header: juce_core, importcpp: "#.setAffinityMask(@)".}
proc wait*(this: Thread, timeOutMilliseconds: float64): bool {.header: juce_core, importcpp: "#.wait(@)".}
proc notify*(this: Thread) {.header: juce_core, importcpp: "#.notify()".}
proc getThreadId*(this: Thread): pointer {.header: juce_core, importcpp: "#.getThreadId()".}
proc getThreadName*(this: Thread): String {.header: juce_core, importcpp: "#.getThreadName()".}
proc `==`*(this: Thread, other: Thread): bool {.error: "juce::Thread defines no operator==; compare a property instead".}

proc hiResTimerCallback*(this: var HighResolutionTimer) {.header: juce_core, importcpp: "#.hiResTimerCallback()".}
proc startTimer*(this: var HighResolutionTimer, intervalInMilliseconds: cint) {.header: juce_core, importcpp: "#.startTimer(@)".}
proc stopTimer*(this: var HighResolutionTimer) {.header: juce_core, importcpp: "#.stopTimer()".}
proc isTimerRunning*(this: HighResolutionTimer): bool {.header: juce_core, importcpp: "#.isTimerRunning()".}
proc getTimerInterval*(this: HighResolutionTimer): cint {.header: juce_core, importcpp: "#.getTimerInterval()".}
proc `==`*(this: HighResolutionTimer, other: HighResolutionTimer): bool {.error: "juce::HighResolutionTimer defines no operator==; compare a property instead".}

proc makeThreadPoolJob*(name: String): ThreadPoolJob {.header: juce_core, importcpp: "juce::ThreadPoolJob(@)".}
proc getJobName*(this: ThreadPoolJob): String {.header: juce_core, importcpp: "#.getJobName()".}
proc setJobName*(this: var ThreadPoolJob, newName: String) {.header: juce_core, importcpp: "#.setJobName(@)".}
# proc runJob*(this: var ThreadPoolJob): ThreadPoolJobJobStatus {.header: juce_core, importcpp: "#.runJob()".}
proc isRunning*(this: ThreadPoolJob): bool {.header: juce_core, importcpp: "#.isRunning()".}
proc shouldExit*(this: ThreadPoolJob): bool {.header: juce_core, importcpp: "#.shouldExit()".}
proc signalJobShouldExit*(this: var ThreadPoolJob) {.header: juce_core, importcpp: "#.signalJobShouldExit()".}
# proc addListener*(this: var ThreadPoolJob, arg1: ptr ThreadListener) {.header: juce_core, importcpp: "#.addListener(@)".}
# proc removeListener*(this: var ThreadPoolJob, arg1: ptr ThreadListener) {.header: juce_core, importcpp: "#.removeListener(@)".}
proc `==`*(this: ThreadPoolJob, other: ThreadPoolJob): bool {.error: "juce::ThreadPoolJob defines no operator==; compare a property instead".}

proc withThreadName*(this: ThreadPoolOptions, newThreadName: String): ThreadPoolOptions {.header: juce_core, importcpp: "#.withThreadName(@)".}
proc withNumberOfThreads*(this: ThreadPoolOptions, newNumberOfThreads: cint): ThreadPoolOptions {.header: juce_core, importcpp: "#.withNumberOfThreads(@)".}
proc withThreadStackSizeBytes*(this: ThreadPoolOptions, newThreadStackSizeBytes: uint64): ThreadPoolOptions {.header: juce_core, importcpp: "#.withThreadStackSizeBytes(@)".}
proc withDesiredThreadPriority*(this: ThreadPoolOptions, newDesiredThreadPriority: ThreadPriority): ThreadPoolOptions {.header: juce_core, importcpp: "#.withDesiredThreadPriority(@)".}
proc `==`*(this: ThreadPoolOptions, other: ThreadPoolOptions): bool {.error: "juce::ThreadPoolOptions defines no operator==; compare a property instead".}

proc makeThreadPool*(options: ThreadPoolOptions): ThreadPool {.header: juce_core, importcpp: "juce::ThreadPool(@)".}
proc makeThreadPool*(): ThreadPool {.header: juce_core, importcpp: "juce::ThreadPool(@)".}
proc makeThreadPool*(numberOfThreads: cint, threadStackSizeBytes: uint64, desiredThreadPriority: ThreadPriority): ThreadPool {.header: juce_core, importcpp: "juce::ThreadPool(@)".}
proc addJob*(this: var ThreadPool, job: ptr ThreadPoolJob, deleteJobWhenFinished: bool) {.header: juce_core, importcpp: "#.addJob(@)".}
# proc addJob*(this: var ThreadPool, job: std::function<ThreadPoolJob::JobStatus ()>) {.header: juce_core, importcpp: "#.addJob(@)".}
proc addJob*(this: var ThreadPool, job: CppFunctionObjectN0) {.header: juce_core, importcpp: "#.addJob(@)".}
proc removeJob*(this: var ThreadPool, job: ptr ThreadPoolJob, interruptIfRunning: bool, timeOutMilliseconds: cint): bool {.header: juce_core, importcpp: "#.removeJob(@)".}
proc removeAllJobs*(this: var ThreadPool, interruptRunningJobs: bool, timeOutMilliseconds: cint, selectedJobsToRemove: ptr ThreadPoolJobSelector = nil): bool {.header: juce_core, importcpp: "#.removeAllJobs(@)".}
proc getNumJobs*(this: ThreadPool): cint {.header: juce_core, importcpp: "#.getNumJobs()".}
proc getNumThreads*(this: ThreadPool): cint {.header: juce_core, importcpp: "#.getNumThreads()".}
proc getJob*(this: ThreadPool, index: cint): ptr ThreadPoolJob {.header: juce_core, importcpp: "#.getJob(@)".}
proc contains*(this: ThreadPool, job: ptr ThreadPoolJob): bool {.header: juce_core, importcpp: "#.contains(@)".}
proc isJobRunning*(this: ThreadPool, job: ptr ThreadPoolJob): bool {.header: juce_core, importcpp: "#.isJobRunning(@)".}
proc waitForJobToFinish*(this: ThreadPool, job: ptr ThreadPoolJob, timeOutMilliseconds: cint): bool {.header: juce_core, importcpp: "#.waitForJobToFinish(@)".}
proc moveJobToFront*(this: var ThreadPool, jobToMove: ptr ThreadPoolJob) {.header: juce_core, importcpp: "#.moveJobToFront(@)".}
proc getNamesOfAllJobs*(this: ThreadPool, onlyReturnActiveJobs: bool): StringArray {.header: juce_core, importcpp: "#.getNamesOfAllJobs(@)".}
proc `==`*(this: ThreadPool, other: ThreadPool): bool {.error: "juce::ThreadPool defines no operator==; compare a property instead".}

proc useTimeSlice*(this: var TimeSliceClient): cint {.header: juce_core, importcpp: "#.useTimeSlice()".}
proc `==`*(this: TimeSliceClient, other: TimeSliceClient): bool {.error: "juce::TimeSliceClient defines no operator==; compare a property instead".}

proc makeTimeSliceThread*(threadName: String): TimeSliceThread {.header: juce_core, importcpp: "juce::TimeSliceThread(@)".}
proc addTimeSliceClient*(this: var TimeSliceThread, clientToAdd: ptr TimeSliceClient, millisecondsBeforeStarting: cint = 0) {.header: juce_core, importcpp: "#.addTimeSliceClient(@)".}
proc moveToFrontOfQueue*(this: var TimeSliceThread, clientToMove: ptr TimeSliceClient) {.header: juce_core, importcpp: "#.moveToFrontOfQueue(@)".}
proc removeTimeSliceClient*(this: var TimeSliceThread, clientToRemove: ptr TimeSliceClient) {.header: juce_core, importcpp: "#.removeTimeSliceClient(@)".}
proc removeAllClients*(this: var TimeSliceThread) {.header: juce_core, importcpp: "#.removeAllClients()".}
proc getNumClients*(this: TimeSliceThread): cint {.header: juce_core, importcpp: "#.getNumClients()".}
proc getClient*(this: TimeSliceThread, index: cint): ptr TimeSliceClient {.header: juce_core, importcpp: "#.getClient(@)".}
proc contains*(this: TimeSliceThread, arg1: ptr TimeSliceClient): bool {.header: juce_core, importcpp: "#.contains(@)".}
proc run*(this: var TimeSliceThread) {.header: juce_core, importcpp: "#.run()".}
proc `==`*(this: TimeSliceThread, other: TimeSliceThread): bool {.error: "juce::TimeSliceThread defines no operator==; compare a property instead".}

proc makeReadWriteLock*(): ReadWriteLock {.header: juce_core, importcpp: "juce::ReadWriteLock(@)".}
proc enterRead*(this: ReadWriteLock) {.header: juce_core, importcpp: "#.enterRead()".}
proc tryEnterRead*(this: ReadWriteLock): bool {.header: juce_core, importcpp: "#.tryEnterRead()".}
proc exitRead*(this: ReadWriteLock) {.header: juce_core, importcpp: "#.exitRead()".}
proc enterWrite*(this: ReadWriteLock) {.header: juce_core, importcpp: "#.enterWrite()".}
proc tryEnterWrite*(this: ReadWriteLock): bool {.header: juce_core, importcpp: "#.tryEnterWrite()".}
proc exitWrite*(this: ReadWriteLock) {.header: juce_core, importcpp: "#.exitWrite()".}
proc `==`*(this: ReadWriteLock, other: ReadWriteLock): bool {.error: "juce::ReadWriteLock defines no operator==; compare a property instead".}

proc makeScopedReadLock*(lock: ReadWriteLock): ScopedReadLock {.header: juce_core, importcpp: "juce::ScopedReadLock(@)".}
proc `==`*(this: ScopedReadLock, other: ScopedReadLock): bool {.error: "juce::ScopedReadLock defines no operator==; compare a property instead".}

proc makeScopedTryReadLock*(lockIn: var ReadWriteLock): ScopedTryReadLock {.header: juce_core, importcpp: "juce::ScopedTryReadLock(@)".}
proc makeScopedTryReadLock*(lockIn: var ReadWriteLock, acquireLockOnInitialisation: bool): ScopedTryReadLock {.header: juce_core, importcpp: "juce::ScopedTryReadLock(@)".}
proc isLocked*(this: ScopedTryReadLock): bool {.header: juce_core, importcpp: "#.isLocked()".}
proc retryLock*(this: var ScopedTryReadLock): bool {.header: juce_core, importcpp: "#.retryLock()".}
proc `==`*(this: ScopedTryReadLock, other: ScopedTryReadLock): bool {.error: "juce::ScopedTryReadLock defines no operator==; compare a property instead".}

proc makeScopedWriteLock*(lock: ReadWriteLock): ScopedWriteLock {.header: juce_core, importcpp: "juce::ScopedWriteLock(@)".}
proc `==`*(this: ScopedWriteLock, other: ScopedWriteLock): bool {.error: "juce::ScopedWriteLock defines no operator==; compare a property instead".}

proc makeScopedTryWriteLock*(lockIn: var ReadWriteLock): ScopedTryWriteLock {.header: juce_core, importcpp: "juce::ScopedTryWriteLock(@)".}
proc makeScopedTryWriteLock*(lockIn: var ReadWriteLock, acquireLockOnInitialisation: bool): ScopedTryWriteLock {.header: juce_core, importcpp: "juce::ScopedTryWriteLock(@)".}
proc isLocked*(this: ScopedTryWriteLock): bool {.header: juce_core, importcpp: "#.isLocked()".}
proc retryLock*(this: var ScopedTryWriteLock): bool {.header: juce_core, importcpp: "#.retryLock()".}
proc `==`*(this: ScopedTryWriteLock, other: ScopedTryWriteLock): bool {.error: "juce::ScopedTryWriteLock defines no operator==; compare a property instead".}

proc makeIPAddress*(): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(bytes: ptr uint8, IPv6: bool): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(bytes: ptr uint16): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(address1: uint8, address2: uint8, address3: uint8, address4: uint8): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(address1: uint16, address2: uint16, address3: uint16, address4: uint16, address5: uint16, address6: uint16, address7: uint16, address8: uint16): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(asNativeEndian32Bit: uint32): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc makeIPAddress*(address: String): IPAddress {.header: juce_core, importcpp: "juce::IPAddress(@)".}
proc isNull*(this: IPAddress): bool {.header: juce_core, importcpp: "#.isNull()".}
proc toString*(this: IPAddress): String {.header: juce_core, importcpp: "#.toString()".}
proc compare*(this: IPAddress, arg1: IPAddress): cint {.header: juce_core, importcpp: "#.compare(@)".}
proc `==`*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `<`*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator<(@)".}
# proc operator>*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator>(@)".}
proc `<=`*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator<=(@)".}
# proc operator>=*(this: IPAddress, arg1: IPAddress): bool {.header: juce_core, importcpp: "#.operator>=(@)".}

proc makeMACAddress*(): MACAddress {.header: juce_core, importcpp: "juce::MACAddress(@)".}
# proc makeMACAddress*(bytes: uint8[6]): MACAddress {.header: juce_core, importcpp: "juce::MACAddress(@)".}
proc makeMACAddress*(address: StringRef): MACAddress {.header: juce_core, importcpp: "juce::MACAddress(@)".}
proc `MACAddress=`*(this: var MACAddress, arg1: MACAddress): var MACAddress {.header: juce_core, importcpp: "#.operator=(@)".}
proc getBytes*(this: MACAddress): ptr uint8 {.header: juce_core, importcpp: "#.getBytes()".}
proc toString*(this: MACAddress): String {.header: juce_core, importcpp: "#.toString()".}
proc toString*(this: MACAddress, separator: StringRef): String {.header: juce_core, importcpp: "#.toString(@)".}
proc toInt64*(this: MACAddress): int64 {.header: juce_core, importcpp: "#.toInt64()".}
proc isNull*(this: MACAddress): bool {.header: juce_core, importcpp: "#.isNull()".}
proc `==`*(this: MACAddress, arg1: MACAddress): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: MACAddress, arg1: MACAddress): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc makeNamedPipe*(): NamedPipe {.header: juce_core, importcpp: "juce::NamedPipe(@)".}
proc openExisting*(this: var NamedPipe, pipeName: String): bool {.header: juce_core, importcpp: "#.openExisting(@)".}
proc createNewPipe*(this: var NamedPipe, pipeName: String, mustNotExist: bool = false): bool {.header: juce_core, importcpp: "#.createNewPipe(@)".}
proc close*(this: var NamedPipe) {.header: juce_core, importcpp: "#.close()".}
proc isOpen*(this: NamedPipe): bool {.header: juce_core, importcpp: "#.isOpen()".}
proc getName*(this: NamedPipe): String {.header: juce_core, importcpp: "#.getName()".}
proc read*(this: var NamedPipe, destBuffer: pointer, maxBytesToRead: cint, timeOutMilliseconds: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc write*(this: var NamedPipe, sourceBuffer: constPointer, numBytesToWrite: cint, timeOutMilliseconds: cint): cint {.header: juce_core, importcpp: "#.write(@)".}
proc `==`*(this: NamedPipe, other: NamedPipe): bool {.error: "juce::NamedPipe defines no operator==; compare a property instead".}

proc withReceiveBufferSize*(this: SocketOptions, size: cint): SocketOptions {.header: juce_core, importcpp: "#.withReceiveBufferSize(@)".}
proc withSendBufferSize*(this: SocketOptions, size: cint): SocketOptions {.header: juce_core, importcpp: "#.withSendBufferSize(@)".}
proc getReceiveBufferSize*(this: SocketOptions): CppOptional[cint] {.header: juce_core, importcpp: "#.getReceiveBufferSize()".}
proc getSendBufferSize*(this: SocketOptions): CppOptional[cint] {.header: juce_core, importcpp: "#.getSendBufferSize()".}
proc `==`*(this: SocketOptions, other: SocketOptions): bool {.error: "juce::SocketOptions defines no operator==; compare a property instead".}

proc makeStreamingSocket*(): StreamingSocket {.header: juce_core, importcpp: "juce::StreamingSocket(@)".}
proc makeStreamingSocket*(optionsIn: SocketOptions): StreamingSocket {.header: juce_core, importcpp: "juce::StreamingSocket(@)".}
proc bindToPort*(this: var StreamingSocket, localPortNumber: cint): bool {.header: juce_core, importcpp: "#.bindToPort(@)".}
proc bindToPort*(this: var StreamingSocket, localPortNumber: cint, localAddress: String): bool {.header: juce_core, importcpp: "#.bindToPort(@)".}
proc getBoundPort*(this: StreamingSocket): cint {.header: juce_core, importcpp: "#.getBoundPort()".}
proc connect*(this: var StreamingSocket, remoteHostname: String, remotePortNumber: cint, timeOutMillisecs: cint = 3000): bool {.header: juce_core, importcpp: "#.connect(@)".}
proc isConnected*(this: StreamingSocket): bool {.header: juce_core, importcpp: "#.isConnected()".}
proc close*(this: var StreamingSocket) {.header: juce_core, importcpp: "#.close()".}
proc getHostName*(this: StreamingSocket): String {.header: juce_core, importcpp: "#.getHostName()".}
proc getPort*(this: StreamingSocket): cint {.header: juce_core, importcpp: "#.getPort()".}
proc isLocal*(this: StreamingSocket): bool {.header: juce_core, importcpp: "#.isLocal()".}
proc getRawSocketHandle*(this: StreamingSocket): cint {.header: juce_core, importcpp: "#.getRawSocketHandle()".}
proc waitUntilReady*(this: var StreamingSocket, readyForReading: bool, timeoutMsecs: cint): cint {.header: juce_core, importcpp: "#.waitUntilReady(@)".}
proc read*(this: var StreamingSocket, destBuffer: pointer, maxBytesToRead: cint, blockUntilSpecifiedAmountHasArrived: bool): cint {.header: juce_core, importcpp: "#.read(@)".}
proc write*(this: var StreamingSocket, sourceBuffer: constPointer, numBytesToWrite: cint): cint {.header: juce_core, importcpp: "#.write(@)".}
proc createListener*(this: var StreamingSocket, portNumber: cint, localHostName: String): bool {.header: juce_core, importcpp: "#.createListener(@)".}
proc waitForNextConnection*(this: StreamingSocket): ptr StreamingSocket {.header: juce_core, importcpp: "#.waitForNextConnection()".}
proc `==`*(this: StreamingSocket, other: StreamingSocket): bool {.error: "juce::StreamingSocket defines no operator==; compare a property instead".}

proc makeDatagramSocket*(enableBroadcasting: bool, optionsIn: SocketOptions): DatagramSocket {.header: juce_core, importcpp: "juce::DatagramSocket(@)".}
proc makeDatagramSocket*(enableBroadcasting: bool): DatagramSocket {.header: juce_core, importcpp: "juce::DatagramSocket(@)".}
proc makeDatagramSocket*(): DatagramSocket {.header: juce_core, importcpp: "juce::DatagramSocket(@)".}
proc bindToPort*(this: var DatagramSocket, localPortNumber: cint): bool {.header: juce_core, importcpp: "#.bindToPort(@)".}
proc bindToPort*(this: var DatagramSocket, localPortNumber: cint, localAddress: String): bool {.header: juce_core, importcpp: "#.bindToPort(@)".}
proc getBoundPort*(this: DatagramSocket): cint {.header: juce_core, importcpp: "#.getBoundPort()".}
proc getRawSocketHandle*(this: DatagramSocket): cint {.header: juce_core, importcpp: "#.getRawSocketHandle()".}
proc waitUntilReady*(this: var DatagramSocket, readyForReading: bool, timeoutMsecs: cint): cint {.header: juce_core, importcpp: "#.waitUntilReady(@)".}
proc read*(this: var DatagramSocket, destBuffer: pointer, maxBytesToRead: cint, blockUntilSpecifiedAmountHasArrived: bool): cint {.header: juce_core, importcpp: "#.read(@)".}
proc read*(this: var DatagramSocket, destBuffer: pointer, maxBytesToRead: cint, blockUntilSpecifiedAmountHasArrived: bool, senderIPAddress: var String, senderPortNumber: var cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc write*(this: var DatagramSocket, remoteHostname: String, remotePortNumber: cint, sourceBuffer: constPointer, numBytesToWrite: cint): cint {.header: juce_core, importcpp: "#.write(@)".}
proc shutdown*(this: var DatagramSocket) {.header: juce_core, importcpp: "#.shutdown()".}
proc joinMulticast*(this: var DatagramSocket, multicastIPAddress: String): bool {.header: juce_core, importcpp: "#.joinMulticast(@)".}
proc leaveMulticast*(this: var DatagramSocket, multicastIPAddress: String): bool {.header: juce_core, importcpp: "#.leaveMulticast(@)".}
proc setMulticastLoopbackEnabled*(this: var DatagramSocket, enableLoopback: bool): bool {.header: juce_core, importcpp: "#.setMulticastLoopbackEnabled(@)".}
proc setEnablePortReuse*(this: var DatagramSocket, enabled: bool): bool {.header: juce_core, importcpp: "#.setEnablePortReuse(@)".}
proc `==`*(this: DatagramSocket, other: DatagramSocket): bool {.error: "juce::DatagramSocket defines no operator==; compare a property instead".}

proc makeURL*(): URL {.header: juce_core, importcpp: "juce::URL(@)".}
proc makeURL*(url: String): URL {.header: juce_core, importcpp: "juce::URL(@)".}
proc makeURL*(localFile: File): URL {.header: juce_core, importcpp: "juce::URL(@)".}
proc `==`*(this: URL, arg1: URL): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: URL, arg1: URL): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc toString*(this: URL, includeGetParameters: bool): String {.header: juce_core, importcpp: "#.toString(@)".}
proc isEmpty*(this: URL): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc isWellFormed*(this: URL): bool {.header: juce_core, importcpp: "#.isWellFormed()".}
proc getDomain*(this: URL): String {.header: juce_core, importcpp: "#.getDomain()".}
proc getSubPath*(this: URL, includeGetParameters: bool = false): String {.header: juce_core, importcpp: "#.getSubPath(@)".}
proc getQueryString*(this: URL): String {.header: juce_core, importcpp: "#.getQueryString()".}
proc getAnchorString*(this: URL): String {.header: juce_core, importcpp: "#.getAnchorString()".}
proc getScheme*(this: URL): String {.header: juce_core, importcpp: "#.getScheme()".}
proc isLocalFile*(this: URL): bool {.header: juce_core, importcpp: "#.isLocalFile()".}
proc getLocalFile*(this: URL): File {.header: juce_core, importcpp: "#.getLocalFile()".}
proc getFileName*(this: URL): String {.header: juce_core, importcpp: "#.getFileName()".}
proc getPort*(this: URL): cint {.header: juce_core, importcpp: "#.getPort()".}
proc getOrigin*(this: URL): String {.header: juce_core, importcpp: "#.getOrigin()".}
proc withNewDomainAndPath*(this: URL, newFullPath: String): URL {.header: juce_core, importcpp: "#.withNewDomainAndPath(@)".}
proc withNewSubPath*(this: URL, newPath: String): URL {.header: juce_core, importcpp: "#.withNewSubPath(@)".}
proc getParentURL*(this: URL): URL {.header: juce_core, importcpp: "#.getParentURL()".}
proc getChildURL*(this: URL, subPath: String): URL {.header: juce_core, importcpp: "#.getChildURL(@)".}
proc withParameter*(this: URL, parameterName: String, parameterValue: String): URL {.header: juce_core, importcpp: "#.withParameter(@)".}
proc withParameters*(this: URL, parametersToAdd: StringPairArray): URL {.header: juce_core, importcpp: "#.withParameters(@)".}
proc withAnchor*(this: URL, anchor: String): URL {.header: juce_core, importcpp: "#.withAnchor(@)".}
proc withFileToUpload*(this: URL, parameterName: String, fileToUpload: File, mimeType: String): URL {.header: juce_core, importcpp: "#.withFileToUpload(@)".}
proc withDataToUpload*(this: URL, parameterName: String, filename: String, fileContentToUpload: MemoryBlock, mimeType: String): URL {.header: juce_core, importcpp: "#.withDataToUpload(@)".}
proc getParameterNames*(this: URL): StringArray {.header: juce_core, importcpp: "#.getParameterNames()".}
proc getParameterValues*(this: URL): StringArray {.header: juce_core, importcpp: "#.getParameterValues()".}
proc withPOSTData*(this: URL, postData: String): URL {.header: juce_core, importcpp: "#.withPOSTData(@)".}
proc withPOSTData*(this: URL, postData: MemoryBlock): URL {.header: juce_core, importcpp: "#.withPOSTData(@)".}
proc getPostData*(this: URL): String {.header: juce_core, importcpp: "#.getPostData()".}
proc getPostDataAsMemoryBlock*(this: URL): MemoryBlock {.header: juce_core, importcpp: "#.getPostDataAsMemoryBlock()".}
proc launchInDefaultBrowser*(this: URL): bool {.header: juce_core, importcpp: "#.launchInDefaultBrowser()".}
# proc createInputStream*(this: URL, options: URLInputStreamOptions): UniquePtr[InputStream] {.header: juce_core, importcpp: "#.createInputStream(@)".}
proc createOutputStream*(this: URL): UniquePtr[OutputStream] {.header: juce_core, importcpp: "#.createOutputStream()".}
# proc downloadToFile*(this: var URL, targetLocation: File, extraHeaders: String, listener: ptr URLDownloadTaskListener = nil, usePostCommand: bool = false): UniquePtr[URLDownloadTask] {.header: juce_core, importcpp: "#.downloadToFile(@)".}
# proc downloadToFile*(this: var URL, targetLocation: File, options: URLDownloadTaskOptions): UniquePtr[URLDownloadTask] {.header: juce_core, importcpp: "#.downloadToFile(@)".}
proc readEntireBinaryStream*(this: URL, destData: var MemoryBlock, usePostCommand: bool = false): bool {.header: juce_core, importcpp: "#.readEntireBinaryStream(@)".}
proc readEntireTextStream*(this: URL, usePostCommand: bool = false): String {.header: juce_core, importcpp: "#.readEntireTextStream(@)".}
proc readEntireXmlStream*(this: URL, usePostCommand: bool = false): UniquePtr[XmlElement] {.header: juce_core, importcpp: "#.readEntireXmlStream(@)".}
# proc createInputStream*(this: URL, doPostLikeRequest: bool, progressCallback: ptr bool (pointer, int, int) = nil, progressCallbackContext: pointer = nil, extraHeaders: String, connectionTimeOutMs: cint = 0, responseHeaders: ptr StringPairArray = nil, statusCode: ptr cint = nil, numRedirectsToFollow: cint = 5, httpRequestCmd: String): UniquePtr[InputStream] {.header: juce_core, importcpp: "#.createInputStream(@)".}

proc makeWebInputStream*(url: URL, addParametersToRequestBody: bool): WebInputStream {.header: juce_core, importcpp: "juce::WebInputStream(@)".}
proc withExtraHeaders*(this: var WebInputStream, extraHeaders: String): var WebInputStream {.header: juce_core, importcpp: "#.withExtraHeaders(@)".}
proc withCustomRequestCommand*(this: var WebInputStream, customRequestCommand: String): var WebInputStream {.header: juce_core, importcpp: "#.withCustomRequestCommand(@)".}
proc withConnectionTimeout*(this: var WebInputStream, timeoutInMs: cint): var WebInputStream {.header: juce_core, importcpp: "#.withConnectionTimeout(@)".}
proc withNumRedirectsToFollow*(this: var WebInputStream, numRedirects: cint): var WebInputStream {.header: juce_core, importcpp: "#.withNumRedirectsToFollow(@)".}
proc connect*(this: var WebInputStream, listener: ptr WebInputStreamListener): bool {.header: juce_core, importcpp: "#.connect(@)".}
proc isError*(this: WebInputStream): bool {.header: juce_core, importcpp: "#.isError()".}
proc cancel*(this: var WebInputStream) {.header: juce_core, importcpp: "#.cancel()".}
proc getRequestHeaders*(this: WebInputStream): StringPairArray {.header: juce_core, importcpp: "#.getRequestHeaders()".}
proc getResponseHeaders*(this: var WebInputStream): StringPairArray {.header: juce_core, importcpp: "#.getResponseHeaders()".}
proc getStatusCode*(this: var WebInputStream): cint {.header: juce_core, importcpp: "#.getStatusCode()".}
proc getTotalLength*(this: var WebInputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc read*(this: var WebInputStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc isExhausted*(this: var WebInputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc getPosition*(this: var WebInputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var WebInputStream, wantedPos: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc `==`*(this: WebInputStream, other: WebInputStream): bool {.error: "juce::WebInputStream defines no operator==; compare a property instead".}

proc makeURLInputSource*(url: URL): URLInputSource {.header: juce_core, importcpp: "juce::URLInputSource(@)".}
proc makeURLInputSource*(url: lent URL): URLInputSource {.header: juce_core, importcpp: "juce::URLInputSource(@)".}
proc createInputStream*(this: var URLInputSource): ptr InputStream {.header: juce_core, importcpp: "#.createInputStream()".}
proc createInputStreamFor*(this: var URLInputSource, relatedItemPath: String): ptr InputStream {.header: juce_core, importcpp: "#.createInputStreamFor(@)".}
proc hashCode*(this: URLInputSource): int64 {.header: juce_core, importcpp: "#.hashCode()".}
proc `==`*(this: URLInputSource, other: URLInputSource): bool {.error: "juce::URLInputSource defines no operator==; compare a property instead".}

proc makePerformanceCounter*(counterName: String, runsPerPrintout: cint, loggingFile: File): PerformanceCounter {.header: juce_core, importcpp: "juce::PerformanceCounter(@)".}
proc start*(this: var PerformanceCounter) {.header: juce_core, importcpp: "#.start()".}
proc stop*(this: var PerformanceCounter): bool {.header: juce_core, importcpp: "#.stop()".}
proc printStatistics*(this: var PerformanceCounter) {.header: juce_core, importcpp: "#.printStatistics()".}
proc getStatisticsAndReset*(this: var PerformanceCounter): PerformanceCounterStatistics {.header: juce_core, importcpp: "#.getStatisticsAndReset()".}
proc `==`*(this: PerformanceCounter, other: PerformanceCounter): bool {.error: "juce::PerformanceCounter defines no operator==; compare a property instead".}

proc makeScopedTimeMeasurement*(resultInSeconds: var float64): ScopedTimeMeasurement {.header: juce_core, importcpp: "juce::ScopedTimeMeasurement(@)".}
proc `==`*(this: ScopedTimeMeasurement, other: ScopedTimeMeasurement): bool {.error: "juce::ScopedTimeMeasurement defines no operator==; compare a property instead".}

proc createTimer*(this: var TimedDiagnostic): ScopedTimeMeasurement {.header: juce_core, importcpp: "#.createTimer()".}
proc isEmpty*(this: TimedDiagnostic): bool {.header: juce_core, importcpp: "#.isEmpty()".}
proc `+`*(this: TimedDiagnostic, other: TimedDiagnostic): TimedDiagnostic {.header: juce_core, importcpp: "#.operator+(@)".}
proc `-`*(this: TimedDiagnostic, other: TimedDiagnostic): TimedDiagnostic {.header: juce_core, importcpp: "#.operator-(@)".}
proc `+=`*(this: var TimedDiagnostic, other: TimedDiagnostic) {.header: juce_core, importcpp: "#.operator+=(@)".}
proc `-=`*(this: var TimedDiagnostic, other: TimedDiagnostic) {.header: juce_core, importcpp: "#.operator-=(@)".}
proc `==`*(this: TimedDiagnostic, other: TimedDiagnostic): bool {.error: "juce::TimedDiagnostic defines no operator==; compare a property instead".}

proc makeUnitTest*(name: String, category: String): UnitTest {.header: juce_core, importcpp: "juce::UnitTest(@)".}
proc getName*(this: UnitTest): String {.header: juce_core, importcpp: "#.getName()".}
proc getCategory*(this: UnitTest): String {.header: juce_core, importcpp: "#.getCategory()".}
proc performTest*(this: var UnitTest, runner: ptr UnitTestRunner) {.header: juce_core, importcpp: "#.performTest(@)".}
proc initialise*(this: var UnitTest) {.header: juce_core, importcpp: "#.initialise()".}
proc shutdown*(this: var UnitTest) {.header: juce_core, importcpp: "#.shutdown()".}
proc runTest*(this: var UnitTest) {.header: juce_core, importcpp: "#.runTest()".}
proc beginTest*(this: var UnitTest, testName: String) {.header: juce_core, importcpp: "#.beginTest(@)".}
proc expect*(this: var UnitTest, testResult: bool, failureMessage: String) {.header: juce_core, importcpp: "#.expect(@)".}
proc logMessage*(this: var UnitTest, message: String) {.header: juce_core, importcpp: "#.logMessage(@)".}
proc getRandom*(this: UnitTest): Random {.header: juce_core, importcpp: "#.getRandom()".}
proc `==`*(this: UnitTest, other: UnitTest): bool {.error: "juce::UnitTest defines no operator==; compare a property instead".}

proc makeUnitTestRunner*(): UnitTestRunner {.header: juce_core, importcpp: "juce::UnitTestRunner(@)".}
proc runTests*(this: var UnitTestRunner, tests: Array[UnitTest], randomSeed: int64 = 0) {.header: juce_core, importcpp: "#.runTests(@)".}
proc runAllTests*(this: var UnitTestRunner, randomSeed: int64 = 0) {.header: juce_core, importcpp: "#.runAllTests(@)".}
proc runTestsInCategory*(this: var UnitTestRunner, category: String, randomSeed: int64 = 0) {.header: juce_core, importcpp: "#.runTestsInCategory(@)".}
proc runTestsWithName*(this: var UnitTestRunner, name: String, randomSeed: int64 = 0) {.header: juce_core, importcpp: "#.runTestsWithName(@)".}
proc setAssertOnFailure*(this: var UnitTestRunner, shouldAssert: bool) {.header: juce_core, importcpp: "#.setAssertOnFailure(@)".}
proc setPassesAreLogged*(this: var UnitTestRunner, shouldDisplayPasses: bool) {.header: juce_core, importcpp: "#.setPassesAreLogged(@)".}
proc getNumResults*(this: UnitTestRunner): cint {.header: juce_core, importcpp: "#.getNumResults()".}
proc getResult*(this: UnitTestRunner, index: cint): ptr UnitTestRunnerTestResult {.header: juce_core, importcpp: "#.getResult(@)".}
proc `==`*(this: UnitTestRunner, other: UnitTestRunner): bool {.error: "juce::UnitTestRunner defines no operator==; compare a property instead".}

proc makeXmlDocument*(documentText: String): XmlDocument {.header: juce_core, importcpp: "juce::XmlDocument(@)".}
proc makeXmlDocument*(file: File): XmlDocument {.header: juce_core, importcpp: "juce::XmlDocument(@)".}
proc getDocumentElement*(this: var XmlDocument, onlyReadOuterDocumentElement: bool = false): UniquePtr[XmlElement] {.header: juce_core, importcpp: "#.getDocumentElement(@)".}
proc getDocumentElementIfTagMatches*(this: var XmlDocument, requiredTag: StringRef): UniquePtr[XmlElement] {.header: juce_core, importcpp: "#.getDocumentElementIfTagMatches(@)".}
proc getLastParseError*(this: XmlDocument): String {.header: juce_core, importcpp: "#.getLastParseError()".}
proc setInputSource*(this: var XmlDocument, newSource: ptr InputSource) {.header: juce_core, importcpp: "#.setInputSource(@)".}
proc setEmptyTextElementsIgnored*(this: var XmlDocument, shouldBeIgnored: bool) {.header: juce_core, importcpp: "#.setEmptyTextElementsIgnored(@)".}
proc `==`*(this: XmlDocument, other: XmlDocument): bool {.error: "juce::XmlDocument defines no operator==; compare a property instead".}

proc equals*(this: XmlAttribute, otherName: StringRef, otherValue: StringRef, ignoreCase: bool): bool {.header: juce_core, importcpp: "#.equals(@)".}
proc equals*(this: XmlAttribute, other: XmlAttribute, ignoreCase: bool): bool {.header: juce_core, importcpp: "#.equals(@)".}
proc `==`*(this: XmlAttribute, other: XmlAttribute): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: XmlAttribute, other: XmlAttribute): bool {.header: juce_core, importcpp: "#.operator!=(@)".}

proc makeXmlElement*(tagName: String): XmlElement {.header: juce_core, importcpp: "juce::XmlElement(@)".}
proc makeXmlElement*(tagName: Identifier): XmlElement {.header: juce_core, importcpp: "juce::XmlElement(@)".}
proc makeXmlElement*(tagNameBegin: CharPointer_UTF8, tagNameEnd: CharPointer_UTF8): XmlElement {.header: juce_core, importcpp: "juce::XmlElement(@)".}
proc `XmlElement=`*(this: var XmlElement, arg1: XmlElement): var XmlElement {.header: juce_core, importcpp: "#.operator=(@)".}
proc `XmlElement=`*(this: var XmlElement, arg1: lent XmlElement): var XmlElement {.header: juce_core, importcpp: "#.operator=(@)".}
proc isEquivalentTo*(this: XmlElement, other: ptr XmlElement, ignoreOrderOfAttributes: bool): bool {.header: juce_core, importcpp: "#.isEquivalentTo(@)".}
proc toString*(this: XmlElement, format: XmlElementTextFormat): String {.header: juce_core, importcpp: "#.toString(@)".}
proc writeTo*(this: XmlElement, output: var OutputStream, format: XmlElementTextFormat) {.header: juce_core, importcpp: "#.writeTo(@)".}
proc writeTo*(this: XmlElement, destinationFile: File, format: XmlElementTextFormat): bool {.header: juce_core, importcpp: "#.writeTo(@)".}
proc getTagName*(this: XmlElement): String {.header: juce_core, importcpp: "#.getTagName()".}
proc getNamespace*(this: XmlElement): String {.header: juce_core, importcpp: "#.getNamespace()".}
proc getTagNameWithoutNamespace*(this: XmlElement): String {.header: juce_core, importcpp: "#.getTagNameWithoutNamespace()".}
proc hasTagName*(this: XmlElement, possibleTagName: StringRef): bool {.header: juce_core, importcpp: "#.hasTagName(@)".}
proc hasTagNameIgnoringNamespace*(this: XmlElement, possibleTagName: StringRef): bool {.header: juce_core, importcpp: "#.hasTagNameIgnoringNamespace(@)".}
proc setTagName*(this: var XmlElement, newTagName: StringRef) {.header: juce_core, importcpp: "#.setTagName(@)".}
proc getNumAttributes*(this: XmlElement): cint {.header: juce_core, importcpp: "#.getNumAttributes()".}
proc getAttributeName*(this: XmlElement, attributeIndex: cint): String {.header: juce_core, importcpp: "#.getAttributeName(@)".}
proc getAttributeValue*(this: XmlElement, attributeIndex: cint): String {.header: juce_core, importcpp: "#.getAttributeValue(@)".}
proc hasAttribute*(this: XmlElement, attributeName: StringRef): bool {.header: juce_core, importcpp: "#.hasAttribute(@)".}
proc getStringAttribute*(this: XmlElement, attributeName: StringRef): String {.header: juce_core, importcpp: "#.getStringAttribute(@)".}
proc getStringAttribute*(this: XmlElement, attributeName: StringRef, defaultReturnValue: String): String {.header: juce_core, importcpp: "#.getStringAttribute(@)".}
proc compareAttribute*(this: XmlElement, attributeName: StringRef, stringToCompareAgainst: StringRef, ignoreCase: bool = false): bool {.header: juce_core, importcpp: "#.compareAttribute(@)".}
proc compareAttribute*(this: XmlElement, attribute: XmlAttribute, ignoreCase: bool = false): bool {.header: juce_core, importcpp: "#.compareAttribute(@)".}
proc getIntAttribute*(this: XmlElement, attributeName: StringRef, defaultReturnValue: cint = 0): cint {.header: juce_core, importcpp: "#.getIntAttribute(@)".}
proc getDoubleAttribute*(this: XmlElement, attributeName: StringRef, defaultReturnValue: float64 = 0.0): float64 {.header: juce_core, importcpp: "#.getDoubleAttribute(@)".}
proc getBoolAttribute*(this: XmlElement, attributeName: StringRef, defaultReturnValue: bool = false): bool {.header: juce_core, importcpp: "#.getBoolAttribute(@)".}
proc setAttribute*(this: var XmlElement, attributeName: Identifier, newValue: String) {.header: juce_core, importcpp: "#.setAttribute(@)".}
proc setAttribute*(this: var XmlElement, attributeName: Identifier, newValue: cint) {.header: juce_core, importcpp: "#.setAttribute(@)".}
proc setAttribute*(this: var XmlElement, attributeName: Identifier, newValue: float64) {.header: juce_core, importcpp: "#.setAttribute(@)".}
proc removeAttribute*(this: var XmlElement, attributeName: Identifier) {.header: juce_core, importcpp: "#.removeAttribute(@)".}
proc removeAllAttributes*(this: var XmlElement) {.header: juce_core, importcpp: "#.removeAllAttributes()".}
proc getFirstChildElement*(this: XmlElement): ptr XmlElement {.header: juce_core, importcpp: "#.getFirstChildElement()".}
proc getNextElement*(this: XmlElement): ptr XmlElement {.header: juce_core, importcpp: "#.getNextElement()".}
proc getNextElementWithTagName*(this: XmlElement, requiredTagName: StringRef): ptr XmlElement {.header: juce_core, importcpp: "#.getNextElementWithTagName(@)".}
proc getNumChildElements*(this: XmlElement): cint {.header: juce_core, importcpp: "#.getNumChildElements()".}
proc getChildElement*(this: XmlElement, index: cint): ptr XmlElement {.header: juce_core, importcpp: "#.getChildElement(@)".}
proc getChildByName*(this: XmlElement, tagNameToLookFor: StringRef): ptr XmlElement {.header: juce_core, importcpp: "#.getChildByName(@)".}
proc getChildByAttribute*(this: XmlElement, attributeName: StringRef, attributeValue: StringRef): ptr XmlElement {.header: juce_core, importcpp: "#.getChildByAttribute(@)".}
proc addChildElement*(this: var XmlElement, newChildElement: ptr XmlElement) {.header: juce_core, importcpp: "#.addChildElement(@)".}
proc insertChildElement*(this: var XmlElement, newChildElement: ptr XmlElement, indexToInsertAt: cint) {.header: juce_core, importcpp: "#.insertChildElement(@)".}
proc prependChildElement*(this: var XmlElement, newChildElement: ptr XmlElement) {.header: juce_core, importcpp: "#.prependChildElement(@)".}
proc createNewChildElement*(this: var XmlElement, tagName: StringRef): ptr XmlElement {.header: juce_core, importcpp: "#.createNewChildElement(@)".}
proc replaceChildElement*(this: var XmlElement, currentChildElement: ptr XmlElement, newChildNode: ptr XmlElement): bool {.header: juce_core, importcpp: "#.replaceChildElement(@)".}
proc removeChildElement*(this: var XmlElement, childToRemove: ptr XmlElement, shouldDeleteTheChild: bool) {.header: juce_core, importcpp: "#.removeChildElement(@)".}
proc deleteAllChildElements*(this: var XmlElement) {.header: juce_core, importcpp: "#.deleteAllChildElements()".}
proc deleteAllChildElementsWithTagName*(this: var XmlElement, tagName: StringRef) {.header: juce_core, importcpp: "#.deleteAllChildElementsWithTagName(@)".}
proc containsChildElement*(this: XmlElement, possibleChild: ptr XmlElement): bool {.header: juce_core, importcpp: "#.containsChildElement(@)".}
proc findParentElementOf*(this: var XmlElement, childToSearchFor: ptr XmlElement): ptr XmlElement {.header: juce_core, importcpp: "#.findParentElementOf(@)".}
proc isTextElement*(this: XmlElement): bool {.header: juce_core, importcpp: "#.isTextElement()".}
proc getText*(this: XmlElement): String {.header: juce_core, importcpp: "#.getText()".}
proc setText*(this: var XmlElement, newText: String) {.header: juce_core, importcpp: "#.setText(@)".}
proc getAllSubText*(this: XmlElement): String {.header: juce_core, importcpp: "#.getAllSubText()".}
proc getChildElementAllSubText*(this: XmlElement, childTagName: StringRef, defaultReturnValue: String): String {.header: juce_core, importcpp: "#.getChildElementAllSubText(@)".}
proc addTextElement*(this: var XmlElement, text: String) {.header: juce_core, importcpp: "#.addTextElement(@)".}
proc deleteAllTextElements*(this: var XmlElement) {.header: juce_core, importcpp: "#.deleteAllTextElements()".}
# proc getChildIterator*(this: XmlElement): Iterator<GetNextElement> {.header: juce_core, importcpp: "#.getChildIterator()".}
# proc getChildWithTagNameIterator*(this: XmlElement, name: StringRef): Iterator<GetNextElementWithTagName> {.header: juce_core, importcpp: "#.getChildWithTagNameIterator(@)".}
# proc getAttributeIterator*(this: XmlElement): AttributeIterator {.header: juce_core, importcpp: "#.getAttributeIterator()".}
proc macroBasedForLoop*(this: XmlElement) {.header: juce_core, importcpp: "#.macroBasedForLoop()".}
proc createDocument*(this: XmlElement, dtdToUse: StringRef, allOnOneLine: bool = false, includeXmlHeader: bool = true, encodingType: StringRef, lineWrapLength: cint = 60): String {.header: juce_core, importcpp: "#.createDocument(@)".}
proc writeToStream*(this: XmlElement, output: var OutputStream, dtdToUse: StringRef, allOnOneLine: bool = false, includeXmlHeader: bool = true, encodingType: StringRef, lineWrapLength: cint = 60) {.header: juce_core, importcpp: "#.writeToStream(@)".}
proc writeToFile*(this: XmlElement, destinationFile: File, dtdToUse: StringRef, encodingType: StringRef, lineWrapLength: cint = 60): bool {.header: juce_core, importcpp: "#.writeToFile(@)".}
proc `==`*(this: XmlElement, other: XmlElement): bool {.error: "juce::XmlElement defines no operator==; compare a property instead".}

proc makeGZIPCompressorOutputStream*(destStream: var OutputStream, compressionLevel: cint, windowBits: cint): GZIPCompressorOutputStream {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream(@)".}
proc makeGZIPCompressorOutputStream*(destStream: ptr OutputStream, compressionLevel: cint, deleteDestStreamWhenDestroyed: bool, windowBits: cint): GZIPCompressorOutputStream {.header: juce_core, importcpp: "juce::GZIPCompressorOutputStream(@)".}
proc flush*(this: var GZIPCompressorOutputStream) {.header: juce_core, importcpp: "#.flush()".}
proc getPosition*(this: var GZIPCompressorOutputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var GZIPCompressorOutputStream, arg1: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc write*(this: var GZIPCompressorOutputStream, arg1: constPointer, arg2: uint64): bool {.header: juce_core, importcpp: "#.write(@)".}
proc `==`*(this: GZIPCompressorOutputStream, other: GZIPCompressorOutputStream): bool {.error: "juce::GZIPCompressorOutputStream defines no operator==; compare a property instead".}

proc makeGZIPDecompressorInputStream*(sourceStream: ptr InputStream, deleteSourceWhenDestroyed: bool, sourceFormat: GZIPDecompressorInputStreamFormat, uncompressedStreamLength: int64): GZIPDecompressorInputStream {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream(@)".}
proc makeGZIPDecompressorInputStream*(sourceStream: var InputStream): GZIPDecompressorInputStream {.header: juce_core, importcpp: "juce::GZIPDecompressorInputStream(@)".}
proc getPosition*(this: var GZIPDecompressorInputStream): int64 {.header: juce_core, importcpp: "#.getPosition()".}
proc setPosition*(this: var GZIPDecompressorInputStream, pos: int64): bool {.header: juce_core, importcpp: "#.setPosition(@)".}
proc getTotalLength*(this: var GZIPDecompressorInputStream): int64 {.header: juce_core, importcpp: "#.getTotalLength()".}
proc isExhausted*(this: var GZIPDecompressorInputStream): bool {.header: juce_core, importcpp: "#.isExhausted()".}
proc read*(this: var GZIPDecompressorInputStream, destBuffer: pointer, maxBytesToRead: cint): cint {.header: juce_core, importcpp: "#.read(@)".}
proc `==`*(this: GZIPDecompressorInputStream, other: GZIPDecompressorInputStream): bool {.error: "juce::GZIPDecompressorInputStream defines no operator==; compare a property instead".}

proc makeZipFile*(file: File): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc makeZipFile*(inputStream: UniquePtr[InputStream]): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc makeZipFile*(inputSource: UniquePtr[InputSource]): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc makeZipFile*(inputStream: var InputStream): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc makeZipFile*(inputStream: ptr InputStream, deleteStreamWhenDestroyed: bool): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc makeZipFile*(inputSource: ptr InputSource): ZipFile {.header: juce_core, importcpp: "juce::ZipFile(@)".}
proc getNumEntries*(this: ZipFile): cint {.header: juce_core, importcpp: "#.getNumEntries()".}
proc getEntry*(this: ZipFile, index: cint): ptr ZipFileZipEntry {.header: juce_core, importcpp: "#.getEntry(@)".}
proc getIndexOfFileName*(this: ZipFile, fileName: String, ignoreCase: bool = false): cint {.header: juce_core, importcpp: "#.getIndexOfFileName(@)".}
proc getEntry*(this: ZipFile, fileName: String, ignoreCase: bool = false): ptr ZipFileZipEntry {.header: juce_core, importcpp: "#.getEntry(@)".}
proc sortEntriesByFilename*(this: var ZipFile) {.header: juce_core, importcpp: "#.sortEntriesByFilename()".}
proc createStreamForEntry*(this: var ZipFile, index: cint): ptr InputStream {.header: juce_core, importcpp: "#.createStreamForEntry(@)".}
proc createStreamForEntry*(this: var ZipFile, entry: ZipFileZipEntry): ptr InputStream {.header: juce_core, importcpp: "#.createStreamForEntry(@)".}
proc uncompressTo*(this: var ZipFile, targetDirectory: File, shouldOverwriteFiles: bool = true): Result {.header: juce_core, importcpp: "#.uncompressTo(@)".}
proc uncompressEntry*(this: var ZipFile, index: cint, targetDirectory: File, shouldOverwriteFiles: bool = true): Result {.header: juce_core, importcpp: "#.uncompressEntry(@)".}
proc uncompressEntry*(this: var ZipFile, index: cint, targetDirectory: File, overwriteFiles: ZipFileOverwriteFiles, followSymlinks: ZipFileFollowSymlinks): Result {.header: juce_core, importcpp: "#.uncompressEntry(@)".}
proc `==`*(this: ZipFile, other: ZipFile): bool {.error: "juce::ZipFile defines no operator==; compare a property instead".}

proc makePropertySet*(ignoreCaseOfKeyNames: bool): PropertySet {.header: juce_core, importcpp: "juce::PropertySet(@)".}
proc `PropertySet=`*(this: var PropertySet, other: PropertySet): var PropertySet {.header: juce_core, importcpp: "#.operator=(@)".}
proc getValue*(this: PropertySet, keyName: StringRef, defaultReturnValue: String): String {.header: juce_core, importcpp: "#.getValue(@)".}
proc getIntValue*(this: PropertySet, keyName: StringRef, defaultReturnValue: cint = 0): cint {.header: juce_core, importcpp: "#.getIntValue(@)".}
proc getDoubleValue*(this: PropertySet, keyName: StringRef, defaultReturnValue: float64 = 0.0): float64 {.header: juce_core, importcpp: "#.getDoubleValue(@)".}
proc getBoolValue*(this: PropertySet, keyName: StringRef, defaultReturnValue: bool = false): bool {.header: juce_core, importcpp: "#.getBoolValue(@)".}
proc getXmlValue*(this: PropertySet, keyName: StringRef): UniquePtr[XmlElement] {.header: juce_core, importcpp: "#.getXmlValue(@)".}
proc setValue*(this: var PropertySet, keyName: StringRef, value: juce_var) {.header: juce_core, importcpp: "#.setValue(@)".}
proc setValue*(this: var PropertySet, keyName: StringRef, xml: ptr XmlElement) {.header: juce_core, importcpp: "#.setValue(@)".}
proc addAllPropertiesFrom*(this: var PropertySet, source: PropertySet) {.header: juce_core, importcpp: "#.addAllPropertiesFrom(@)".}
proc removeValue*(this: var PropertySet, keyName: StringRef) {.header: juce_core, importcpp: "#.removeValue(@)".}
proc containsKey*(this: PropertySet, keyName: StringRef): bool {.header: juce_core, importcpp: "#.containsKey(@)".}
proc clear*(this: var PropertySet) {.header: juce_core, importcpp: "#.clear()".}
proc getAllProperties*(this: var PropertySet): var StringPairArray {.header: juce_core, importcpp: "#.getAllProperties()".}
proc getLock*(this: PropertySet): CriticalSection {.header: juce_core, importcpp: "#.getLock()".}
proc createXml*(this: PropertySet, nodeName: String): UniquePtr[XmlElement] {.header: juce_core, importcpp: "#.createXml(@)".}
proc restoreFromXml*(this: var PropertySet, xml: XmlElement) {.header: juce_core, importcpp: "#.restoreFromXml(@)".}
proc setFallbackPropertySet*(this: var PropertySet, fallbackProperties: ptr PropertySet) {.header: juce_core, importcpp: "#.setFallbackPropertySet(@)".}
proc getFallbackPropertySet*(this: PropertySet): ptr PropertySet {.header: juce_core, importcpp: "#.getFallbackPropertySet()".}
proc `==`*(this: PropertySet, other: PropertySet): bool {.error: "juce::PropertySet defines no operator==; compare a property instead".}

proc `==`*(this: Reservoir, other: Reservoir): bool {.error: "juce::Reservoir defines no operator==; compare a property instead".}

proc makeAndroidDocumentInfo*(): AndroidDocumentInfo {.header: juce_core, importcpp: "juce::AndroidDocumentInfo(@)".}
proc exists*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.exists()".}
proc isDirectory*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.isDirectory()".}
proc isFile*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.isFile()".}
proc canRead*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canRead()".}
proc canWrite*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canWrite()".}
proc canDelete*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canDelete()".}
proc canCreateChildren*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canCreateChildren()".}
proc canRename*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canRename()".}
proc canCopy*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canCopy()".}
proc canMove*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.canMove()".}
proc isVirtual*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.isVirtual()".}
proc getName*(this: AndroidDocumentInfo): String {.header: juce_core, importcpp: "#.getName()".}
proc getType*(this: AndroidDocumentInfo): String {.header: juce_core, importcpp: "#.getType()".}
proc getLastModified*(this: AndroidDocumentInfo): int64 {.header: juce_core, importcpp: "#.getLastModified()".}
proc isLastModifiedValid*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.isLastModifiedValid()".}
proc getSizeInBytes*(this: AndroidDocumentInfo): int64 {.header: juce_core, importcpp: "#.getSizeInBytes()".}
proc isSizeInBytesValid*(this: AndroidDocumentInfo): bool {.header: juce_core, importcpp: "#.isSizeInBytesValid()".}
proc `==`*(this: AndroidDocumentInfo, other: AndroidDocumentInfo): bool {.error: "juce::AndroidDocumentInfo defines no operator==; compare a property instead".}

proc getUrl*(this: AndroidDocumentPermission): URL {.header: juce_core, importcpp: "#.getUrl()".}
proc getPersistedTime*(this: AndroidDocumentPermission): int64 {.header: juce_core, importcpp: "#.getPersistedTime()".}
proc isReadPermission*(this: AndroidDocumentPermission): bool {.header: juce_core, importcpp: "#.isReadPermission()".}
proc isWritePermission*(this: AndroidDocumentPermission): bool {.header: juce_core, importcpp: "#.isWritePermission()".}
proc `==`*(this: AndroidDocumentPermission, other: AndroidDocumentPermission): bool {.error: "juce::AndroidDocumentPermission defines no operator==; compare a property instead".}

proc makeAndroidDocument*(): AndroidDocument {.header: juce_core, importcpp: "juce::AndroidDocument(@)".}
proc `AndroidDocument=`*(this: var AndroidDocument, arg1: AndroidDocument): var AndroidDocument {.header: juce_core, importcpp: "#.operator=(@)".}
proc `AndroidDocument=`*(this: var AndroidDocument, arg1: lent AndroidDocument): var AndroidDocument {.header: juce_core, importcpp: "#.operator=(@)".}
proc `==`*(this: AndroidDocument, arg1: AndroidDocument): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: AndroidDocument, arg1: AndroidDocument): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc deleteDocument*(this: AndroidDocument): bool {.header: juce_core, importcpp: "#.deleteDocument()".}
proc renameTo*(this: var AndroidDocument, newDisplayName: String): bool {.header: juce_core, importcpp: "#.renameTo(@)".}
proc createChildDocumentWithTypeAndName*(this: AndroidDocument, `type`: String, name: String): AndroidDocument {.header: juce_core, importcpp: "#.createChildDocumentWithTypeAndName(@)".}
proc createChildDirectory*(this: AndroidDocument, name: String): AndroidDocument {.header: juce_core, importcpp: "#.createChildDirectory(@)".}
proc hasValue*(this: AndroidDocument): bool {.header: juce_core, importcpp: "#.hasValue()".}
proc createInputStream*(this: AndroidDocument): UniquePtr[InputStream] {.header: juce_core, importcpp: "#.createInputStream()".}
proc createOutputStream*(this: AndroidDocument): UniquePtr[OutputStream] {.header: juce_core, importcpp: "#.createOutputStream()".}
proc getUrl*(this: AndroidDocument): URL {.header: juce_core, importcpp: "#.getUrl()".}
proc getInfo*(this: AndroidDocument): AndroidDocumentInfo {.header: juce_core, importcpp: "#.getInfo()".}
proc copyDocumentToParentDocument*(this: AndroidDocument, target: AndroidDocument): AndroidDocument {.header: juce_core, importcpp: "#.copyDocumentToParentDocument(@)".}
proc moveDocumentFromParentToParent*(this: var AndroidDocument, currentParent: AndroidDocument, newParent: AndroidDocument): bool {.header: juce_core, importcpp: "#.moveDocumentFromParentToParent(@)".}
proc getNativeInfo*(this: AndroidDocument): AndroidDocumentNativeInfo {.header: juce_core, importcpp: "#.getNativeInfo()".}

proc makeAndroidDocumentIterator*(): AndroidDocumentIterator {.header: juce_core, importcpp: "juce::AndroidDocumentIterator(@)".}
proc `==`*(this: AndroidDocumentIterator, other: AndroidDocumentIterator): bool {.header: juce_core, importcpp: "#.operator==(@)".}
# proc operator!=*(this: AndroidDocumentIterator, other: AndroidDocumentIterator): bool {.header: juce_core, importcpp: "#.operator!=(@)".}
proc `*`*(this: AndroidDocumentIterator): AndroidDocument {.header: juce_core, importcpp: "#.operator*()".}
proc `inc`*(this: var AndroidDocumentIterator): var AndroidDocumentIterator {.header: juce_core, importcpp: "#.operator++()".}
# proc begin*(this: AndroidDocumentIterator): AndroidDocumentIterator {.header: juce_core, importcpp: "#.begin()".}
# proc `end`*(this: AndroidDocumentIterator): AndroidDocumentIterator {.header: juce_core, importcpp: "#.end()".}

proc makeAndroidDocumentInputSource*(doc: AndroidDocument): AndroidDocumentInputSource {.header: juce_core, importcpp: "juce::AndroidDocumentInputSource(@)".}
proc createInputStream*(this: var AndroidDocumentInputSource): ptr InputStream {.header: juce_core, importcpp: "#.createInputStream()".}
proc createInputStreamFor*(this: var AndroidDocumentInputSource, relatedItemPath: String): ptr InputStream {.header: juce_core, importcpp: "#.createInputStreamFor(@)".}
proc hashCode*(this: AndroidDocumentInputSource): int64 {.header: juce_core, importcpp: "#.hashCode()".}
proc `==`*(this: AndroidDocumentInputSource, other: AndroidDocumentInputSource): bool {.error: "juce::AndroidDocumentInputSource defines no operator==; compare a property instead".}



include juce_core_lifting

proc `$`*(this: MemoryBlock): string = $this.toString()
proc `$`*(this: Identifier): string = $this.toString()
proc `$`*(this: Uuid): string = $this.toString()
proc `$`*(this: juce_var): string = $this.toString()
proc `$`*(this: MemoryOutputStream): string = $this.toString()
proc `$`*(this: FileSearchPath): string = $this.toString()
proc `$`*(this: Expression): string = $this.toString()
proc `$`*(this: IPAddress): string = $this.toString()
proc `$`*(this: MACAddress): string = $this.toString()
