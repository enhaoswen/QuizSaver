// WindowManager.cpp
#include "WindowManager.h"
#include<iostream>

WindowManager::WindowManager(QWindow *mainWin, QWindow *childWin): m_mainWindow(mainWin), m_childWindow(childWin){
    connect(m_mainWindow, &QWindow::xChanged, this, &WindowManager::onMainWindowMoved);
    connect(m_mainWindow, &QWindow::yChanged, this, &WindowManager::onMainWindowMoved);
    connect(m_mainWindow, &QWindow::focusObjectChanged, this, &WindowManager::onWindowFocusChanged);

    onMainWindowMoved();
}

void WindowManager::startMove(){
    m_mainWindow->startSystemMove();
}

void WindowManager::onWindowFocusChanged(){
    m_childWindow->raise();
    m_mainWindow->raise();
}

void WindowManager::onMainWindowMoved(){
    m_childWindow->setX(m_mainWindow->x() + 210);
    m_childWindow->setY(m_mainWindow->y() + 10);

}
