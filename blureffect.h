#ifndef BLUREFFECT_H
#define BLUREFFECT_H

#include <QObject>
#include <QQuickWindow>

class BlurEffect : public QObject {
    Q_OBJECT
    Q_PROPERTY(QQuickWindow* window READ window WRITE setWindow NOTIFY windowChanged)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(int blurStrength READ blurStrength WRITE setBlurStrength NOTIFY blurStrengthChanged)
public:
    explicit BlurEffect(QObject *parent = nullptr);

    QQuickWindow* window() const { return m_window; }
    void setWindow(QQuickWindow* window);

    bool isEnabled() const { return m_enabled; }
    void setEnabled(bool enabled);

    int blurStrength() const { return m_blurStrength; }
    void setBlurStrength(int strength);

signals:
    void windowChanged();
    void enabledChanged();
    void blurStrengthChanged();

private:
    void applyAccent();

    QQuickWindow* m_window = nullptr;
    bool m_enabled = false;
    int m_blurStrength = 0;
};

#endif // BLUREFFECT_H
