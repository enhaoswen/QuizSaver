// WindowManager.h
#include <QObject>
#include <QWindow>

class WindowManager : public QObject
{
    Q_OBJECT
public:
    WindowManager(QWindow *mainWin, QWindow *childWin);

public slots:
    void startMove();
    void onMainWindowMoved();
    void onWindowFocusChanged();

private:
    QWindow *m_mainWindow;
    QWindow *m_childWindow;
};
