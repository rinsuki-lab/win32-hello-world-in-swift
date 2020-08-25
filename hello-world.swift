import WinSDK

let hInstance = GetModuleHandleW(nil)

extension LPCWSTR: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
	public init(stringLiteral: String) {
		var arr = Array<UInt16>(stringLiteral.utf16)
		arr.append(0)
		// TODO: たぶんこれメモリリークする
		let ptr = UnsafeMutablePointer<UInt16>.allocate(capacity: arr.count)
		ptr.initialize(from: &arr, count: arr.count)
		self.init(ptr)
	}
	
	public init(unicodeScalarLiteral value: String) {
		self.init(stringLiteral: value)
	}

	public init(extendedGraphemeClusterLiteral value: String) {
		self.init(stringLiteral: value)
	}
}

func windowProc(hWnd: HWND?, msg: UINT, wParam: WPARAM, lParam: LPARAM) -> LRESULT {
	switch msg {
	case UINT(WM_DESTROY):
		PostQuitMessage(0)
		return 0
	default:
		return DefWindowProcW(hWnd, msg, wParam, lParam)
	}
}

let WINDOW_CLASS_NAME: LPCWSTR = "HelloWorldWindow"

var windowClass = WNDCLASSW()
windowClass.lpfnWndProc = windowProc
windowClass.hInstance = hInstance
windowClass.lpszClassName = WINDOW_CLASS_NAME
windowClass.hbrBackground = .init(OpaquePointer(GetStockObject(WHITE_BRUSH)))
RegisterClassW(&windowClass)

let hWnd = CreateWindowExW(
	0,
	WINDOW_CLASS_NAME,
	"Hello windows world from Swift!! 日本語もオッケー👌！！",
	WS_OVERLAPPEDWINDOW,
	CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
	nil,
	nil,
	hInstance,
	nil
)
ShowWindow(hWnd, SW_SHOW);

var msg = MSG()
while GetMessageW(&msg, nil, 0, 0) {
	TranslateMessage(&msg)
	DispatchMessageW(&msg)
}
