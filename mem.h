#ifndef MEM_H
#define MEM_H

#include<QObject>
#include<sstream>
#include<filesystem>
#include"the_best_json.h"
#include<QString>
#include<iostream>
#include <algorithm>
#include<string>
#include<map>
using namespace std;


class Mem : public QObject{
    
    Q_OBJECT
    Q_PROPERTY(int my_opacity READ my_opacity WRITE setMy_opacity NOTIFY my_opacityChanged FINAL)
    Q_PROPERTY(int my_theme READ my_theme WRITE setmy_theme NOTIFY my_themeChanged FINAL)
    Q_PROPERTY(QString imgSymbol READ imgSymbol WRITE setImgSymbol NOTIFY imgSymbolChanged FINAL)
    Q_PROPERTY(QString img_changed READ img_changed WRITE setImg_changed NOTIFY img_changedChanged FINAL)
    Q_PROPERTY(int my_blur READ my_blur WRITE setMy_blur NOTIFY my_blurChanged FINAL)

public:

    Mem(){
        data = best_json.read_json();

        m_my_opacity = stoi(best_json.find_info("opacity",data));
        m_my_theme = stoi(best_json.find_info("theme",data));
        m_imgSymbol = QString::fromStdString(best_json.find_info("img_path",data));
        m_img_changed = QString::fromStdString(best_json.find_info("img_changed",data));
        m_my_blur = stoi(best_json.find_info("blur",data));
    }

    int my_opacity() const;
    void setMy_opacity(int newMy_opacity);
    int my_theme() const;
    void setmy_theme(int newMy_theme);

    QString imgSymbol() const;
    void setImgSymbol(const QString &newImgSymbol);

    QString img_changed() const;
    void setimg_changed(const QString &newImg_changed);

    Q_INVOKABLE void deleteFile(QString filePath) {

            filesystem::path path(filePath.toStdString());

            if (!std::filesystem::exists(path)) return;

            filesystem::remove(path);
    }

    int my_blur() const;
    void setmy_blur(int newMy_blur);

signals:
    void my_opacityChanged();
    void my_themeChanged();
    void imgSymbolChanged();
    void img_changedChanged();
    void my_blurChanged(int blur);

private:
    int m_my_opacity;
    int m_my_theme;
    the_best_json best_json;
    vector<pair<string,string>> data;
    QString m_imgSymbol;
    QString m_img_changed;
    int m_my_blur;
};

inline int Mem::my_blur() const{
    return m_my_blur;
}

inline void Mem::setmy_blur(int newMy_blur){
    if (m_my_blur == newMy_blur) return;
    m_my_blur = newMy_blur;
    emit my_blurChanged(newMy_blur);

    data[4] = {"blur",to_string(my_blur())};
    best_json.write_json(data);
}

inline QString Mem::img_changed() const{
    return m_img_changed;
}

inline void Mem::setimg_changed(const QString &newImg_changed){
    if (m_img_changed == newImg_changed)  return;
    m_img_changed = newImg_changed;
    emit img_changedChanged();

    data[3] = {"img_changed",img_changed().toStdString()};
    best_json.write_json(data);
}

inline QString Mem::imgSymbol() const{
    return m_imgSymbol;
}

inline void Mem::setImgSymbol(const QString &newImgSymbol){
    if (m_imgSymbol == newImgSymbol) return;
    m_imgSymbol = newImgSymbol;
    emit imgSymbolChanged();

    data[2] = {"img_path", imgSymbol().toStdString()};
    best_json.write_json(data);
}

inline int Mem::my_theme() const{
    return m_my_theme;
}

inline void Mem::setmy_theme(int newMy_theme){
    if (m_my_theme == newMy_theme) return;
    m_my_theme = newMy_theme;
    emit my_themeChanged();

    data[1] = {"theme", to_string(my_theme())};
    best_json.write_json(data);

}

inline int Mem::my_opacity() const{
    return m_my_opacity;
}

inline void Mem::setMy_opacity(int newMy_opacity){
if (m_my_opacity == newMy_opacity) return;
    m_my_opacity = newMy_opacity;
    emit my_opacityChanged();

    data[0] = {"opacity", to_string(my_opacity())};
    best_json.write_json(data);

}

#endif // MEM_H
