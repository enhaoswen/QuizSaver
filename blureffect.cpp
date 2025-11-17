#include "blureffect.h"
#ifdef Q_OS_WIN
#include <windows.h>
// 定义 WinAPI 需要的结构体及函数指针
enum AccentState {
    ACCENT_DISABLED = 0,
    ACCENT_ENABLE_BLURBEHIND = 3,
    ACCENT_ENABLE_ACRYLICBLURBEHIND = 4
};
struct ACCENT_POLICY {
    int AccentState;
    int AccentFlags;
    DWORD GradientColor;
    int AnimationId;
};
enum WindowCompositionAttribute {
    WCA_ACCENT_POLICY = 19
};
struct WindowCompositionAttributeData {
    WindowCompositionAttribute Attribute;
    PVOID              pvData;
    ULONG              cbData;
};
typedef BOOL (WINAPI *pSetWindowCompositionAttribute)(HWND, WindowCompositionAttributeData*);
#endif

BlurEffect::BlurEffect(QObject *parent) : QObject(parent) { }

void BlurEffect::setWindow(QQuickWindow* window) {
    if (m_window == window) return;

    m_window = window;
    emit windowChanged();
    // 可选：首次设置时立即应用当前状态
    applyAccent();
}

void BlurEffect::setEnabled(bool enabled) {
    if (m_enabled == enabled) return;
    m_enabled = enabled;
    emit enabledChanged();
    applyAccent();
}

void BlurEffect::setBlurStrength(int strength) {
    if (m_blurStrength == strength) return;
    // 限制范围 0~100
    m_blurStrength = qBound(0, strength, 100);
    emit blurStrengthChanged();
    // 如果当前已经启用了毛玻璃，则更新效果
    if (m_enabled) applyAccent();
}

void BlurEffect::applyAccent() {
#ifdef Q_OS_WIN
    if (!m_window) return;
    HWND hwnd = (HWND)m_window->winId();
    HMODULE hUser = GetModuleHandle(TEXT("user32.dll"));
    if (!hUser) return;
    auto SetWCA = (pSetWindowCompositionAttribute)
        GetProcAddress(hUser, "SetWindowCompositionAttribute");
    if (!SetWCA) return;

    ACCENT_POLICY accent = {};
    if (m_enabled) {
        accent.AccentState = ACCENT_ENABLE_ACRYLICBLURBEHIND;
        accent.AccentFlags = 0;

        // 调整映射，让低强度也好控制
        float normalized = m_blurStrength / 100.0f;
        normalized = sqrt(normalized); // 前段更灵敏

        // 最大透明度（防止完全不透明）
        int maxAlpha = 180;
        int alpha = int(normalized * maxAlpha);

        // 白色作为背景色，避免染色
        // 0xFFFFFF = 白色，不会发黑
        accent.GradientColor = (alpha << 24) | 0x000000;

    } else {
        accent.AccentState = ACCENT_DISABLED;
    }

    WindowCompositionAttributeData data = {WCA_ACCENT_POLICY, &accent, sizeof(accent)};
    SetWCA(hwnd, &data);
#endif
}
