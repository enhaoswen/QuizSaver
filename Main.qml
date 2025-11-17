
// by 孙恩皓 Swen en hao

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls
import QtQuick.Shapes 1.15
import Qt5Compat.GraphicalEffects
import App 1.0

ApplicationWindow {
    property color bgColor: mem.my_theme === 2 ? "black" : "white"
    property color out_line_color: "gray"
    property color main_color: mem.my_theme === 2 ? "white" : "black"
    property color shadow_color: mem.my_theme === 2 ? "#474747" : "#60000000"
    property color symbol_color: mem.my_theme === 2 ? "#a5e2ff" : "#a1a1a1"
    property color special_shadow_color: mem.my_theme === 2 ? "#ffffff" : "#474747"
    property real w_shadow_radius:25
    property real b_shadow_radius:25
    property real title_shadow_radius:10
    property real form_shadow_radius:10
    property real help_button_shadow_radius :15
    property real drop_shadow_radius :10
    property real l_card_shadow_radius: 15
    property real r_card_shadow_radius: 15
    property int hoveredIndex: -1

    property bool isin_setting:false
    property bool isin_creat:true
    property bool isin_history:false

    property real o_val:handle.x/300
    property real b_val:b_handle.x/3

    property string symbol: "file:///C:/coding/qt/QuizSaver/QS.png"
    property string vocab_card_front:""
    property string vocab_card_back:""
    property string vocab_card_title:""

    property var files_info : ({})


    Behavior on bgColor {ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
    Behavior on out_line_color {ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
    Behavior on main_color {ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
    Behavior on symbol_color {ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}

    Component.onCompleted:{
        m_white_border.visible = mem.my_theme === 1
        m_black_border.visible = mem.my_theme === 2

        blurEffect.window = blur_layer
        blurEffect.enabled = true

        vocab_blurEffect.window = vocab_window
        vocab_blurEffect.enabled = true
        files_info = handleinfo.getFolderInfo()
    }

    function clean_button(){
        isin_creat=false;
        isin_setting=false;
        isin_history=false;
        creat_button_text.color=out_line_color
        setting_button_text.color=out_line_color
        history_button_text.color=out_line_color

        setting_page.visible=false
        creat_page.visible=false
        history_page.visible=false
    }

    function clean_theme_border(){
        m_white_border.visible = false
        m_black_border.visible = false
    }

    function updateTitle() {
        vocab_card_title = handleinfo.init_card()
    }

    function start_vocab_window(){
        vocab_window.visible = true
        main_window.visible = false
        blur_layer.visible = false

        updateTitle()
        var result = handleinfo.processMessage("r")
        vocab_card_front = result[0]
        vocab_card_back = result[1]
    }

    function set_theme(theme_int){

        //1 = white
        //2 = black

        if (theme_int === 1){
            bgColor = "white"
            main_color = "black"
            shadow_color = "#60000000"
            symbol_color = "#a1a1a1"
            special_shadow_color = "#60000000"
        }

        else if(theme_int === 2){
            bgColor = "black"
            main_color = "white"
            shadow_color = "#474747"
            symbol_color = "#a5e2ff"
            special_shadow_color = "#ffffff"
        }
    }

    NumberAnimation {
        id: m_flipable_anim
        target: m_flipable
        property: "x"
        duration: 400
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: t_flipable_anim
        target: t_flipable
        property: "x"
        duration: 400
        easing.type: Easing.InOutQuad
    }

    id: main_window
    width: 1000
    height: 600
    visible: true
    title: "QS"
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

    MouseArea {
        anchors.fill: parent
        drag.target: null
        onPressed: windowManager.startMove()

    }

    QtObject{
        property Window child: Window {
            id: blur_layer
            objectName: "blur_layer"
            width: 780
            height: 580
            visible: true
            color: "transparent"
            flags: Qt.FramelessWindowHint

            SequentialAnimation {
                id: blur_minimizeAnimation
                running: false

                onStarted:page_item.transformOrigin= Item.BottomRight

                ParallelAnimation {
                    NumberAnimation { target: blur_layer; property: "scale"; to: 0.1; duration: 150 }
                    NumberAnimation { target: blur_layer; property: "opacity"; to: 0; duration: 150 }
                }

                ScriptAction {script: blur_layer.close()}
            }
        }
    }

    Window{
        id:vocab_window
        objectName: "vocab_window"
        width:1200
        height:700
        visible:false
        color: "transparent"
        flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

        Rectangle{
            id:vocab_page_item
            anchors.fill:parent
            radius:17
            color:bgColor
            opacity:o_val

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onPressed: function(mouse) {
                    if (help_window_leave_button.containsMouse) {
                        mouse.accepted = false;
                        return;
                    }
                    if (mouse.button === Qt.LeftButton) vocab_window.startSystemMove();

                }
            }
        }

        SequentialAnimation {
            id: vocab_minimizeAnimation
            running: false

            ParallelAnimation {
                NumberAnimation { target: vocab_page_item; property: "scale"; to: 0.1; duration: 150 }
                NumberAnimation { target: vocab_page_item; property: "opacity"; to: 0; duration: 150 }
            }

            ScriptAction {script: {
                    vocab_minimizeAnimation.running = true
                    Qt.quit()
                }}
        }

        Item{
            anchors.fill:parent

            Rectangle {
                id:abcdefg_i_hate_the_proj
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 8
                anchors.rightMargin: 8
                width: 18
                height: 18
                radius: width/2
                color: "red"

                Behavior on color{ColorAnimation {duration: 300}}

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent

                    onEntered: {
                        abcdefg_i_hate_the_proj.color = "#ff7073"
                    }

                    onReleased: vocab_minimizeAnimation.start()

                    onExited: abcdefg_i_hate_the_proj.color = "red"

                }
            }

            Rectangle{
                id:vocab_title
                width:100
                height:30
                anchors.top:parent.top
                anchors.topMargin: 45
                anchors.horizontalCenter: parent.horizontalCenter
                radius:15
                color:bgColor
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 30
                    radius:15
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 200}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }
                Behavior on scale {NumberAnimation{duration:200}}

                MouseArea{
                    anchors.fill:parent1
                    hoverEnabled: true

                    onEntered: vocab_title.scale = 1.02
                    onExited:  vocab_title.scale = 1
                }

                Text{
                    id:vocab_title_number
                    anchors.centerIn: parent
                    text:vocab_card_title
                    font.pixelSize: 16
                    font.bold: true
                    color:main_color
                }
            }

            Flipable {
                id: m_flipable
                width:900
                height:500
                x:151
                y:100

                property bool flipped: false

                transform: Rotation {
                    id: m_rotation
                    origin.x: m_flipable.width / 2
                    origin.y: m_flipable.height / 2
                    axis.x: 1; axis.y: 0; axis.z: 0
                    angle: 0
                }


                front: Rectangle {
                    width: m_flipable.width
                    height: m_flipable.height
                    color: bgColor
                    radius:17
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        samples: 25
                        radius:15
                        color: special_shadow_color
                        Behavior on radius  {NumberAnimation{duration: 200}}
                        Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                    }
                    Text {
                        text: vocab_card_front
                        color:main_color
                        anchors.centerIn: parent
                    }
                }

                back: Rectangle {
                    width: m_flipable.width
                    height: m_flipable.height
                    color: bgColor
                    radius:17
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        samples: 25
                        radius:15
                        color: special_shadow_color
                        Behavior on radius  {NumberAnimation{duration: 200}}
                        Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                    }
                    Text {
                        text: vocab_card_back
                        color:main_color
                        anchors.centerIn: parent
                    }
                }

                states: State {
                    name: "back"
                    when: m_flipable.flipped
                    PropertyChanges { target: m_rotation; angle: 180 }
                }

                transitions: Transition {
                    NumberAnimation { target: m_rotation; property: "angle"; duration: 400 }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: m_flipable.flipped = !m_flipable.flipped

                }
            }

            Flipable {
                id: t_flipable
                width:900
                height:500
                x:2100
                y: 100

                property bool flipped: false

                transform: Rotation {
                    id: t_rotation
                    origin.x: t_flipable.width / 2
                    origin.y: t_flipable.height / 2
                    axis.x: 1; axis.y: 0; axis.z: 0
                    angle: 0
                }


                front: Rectangle {
                    width: t_flipable.width
                    height: t_flipable.height
                    color: bgColor
                    radius:17
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        samples: 25
                        radius:15
                        color: special_shadow_color
                        Behavior on radius  {NumberAnimation{duration: 200}}
                        Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                    }
                    Text {
                        text: vocab_card_front
                        color:main_color
                        anchors.centerIn: parent
                        font.pixelSize: 20
                    }
                }

                back: Rectangle {
                    width: t_flipable.width
                    height: t_flipable.height
                    color: bgColor
                    radius:17
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        samples: 25
                        radius:15
                        color: special_shadow_color
                        Behavior on radius  {NumberAnimation{duration: 200}}
                        Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                    }
                    Text {
                        text: vocab_card_back
                        color:main_color
                        anchors.centerIn: parent
                        font.pixelSize: 20
                    }
                }

                states: State {
                    name: "back"
                    when: t_flipable.flipped
                    PropertyChanges { target: t_rotation; angle: 180 }
                }

                transitions: Transition {
                    NumberAnimation { target: t_rotation; property: "angle"; duration: 400 }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: t_flipable.flipped = !t_flipable.flipped
                }
            }

            Rectangle{
                id:l_card_change_button
                height:30
                width:30
                x:250
                radius:15
                color:bgColor
                border.color:main_color
                border.width:1.5
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 50
                    radius: l_card_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 100}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }
                anchors{
                    top:m_flipable.bottom
                    topMargin: 30
                }

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered:{l_card_shadow_radius = 15}
                    onExited: {l_card_shadow_radius = 13}
                    onPressed:{
                        l_card_shadow_radius = 0

                        m_flipable_anim.from = 151
                        m_flipable_anim.to = 2100
                        m_flipable_anim.start()

                        t_flipable_anim.from = -2100
                        t_flipable_anim.to = 151
                        t_flipable_anim.start()

                        var result = handleinfo.processMessage("2")
                        vocab_card_front = result[0]
                        vocab_card_back = result[1]
                        vocab_card_title = result[2]
                        t_flipable.flipped = false
                    }

                    onReleased:{
                        l_card_shadow_radius = 15
                    }
                }

                Text{
                    anchors.fill:parent
                    font.pixelSize: 19
                    text:"<"
                    horizontalAlignment: Text.AlignHCenter
                    color:main_color
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle{
                id:r_card_change_button
                height:30
                width:30
                x:900
                radius:15
                color:bgColor
                border.color:main_color
                border.width:1.5
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 50
                    radius: l_card_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 100}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }
                anchors{
                    top:m_flipable.bottom
                    topMargin: 30
                }

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered:{l_card_shadow_radius = 15}
                    onExited: {l_card_shadow_radius = 13}
                    onPressed:{
                        l_card_shadow_radius = 0


                        m_flipable_anim.from = 151
                        m_flipable_anim.to = -2100
                        m_flipable_anim.start()

                        t_flipable_anim.from = 2100
                        t_flipable_anim.to = 151
                        t_flipable_anim.start()

                        t_flipable.flipped = false

                        var result = handleinfo.processMessage("1")
                        vocab_card_front = result[0]
                        vocab_card_back = result[1]
                        vocab_card_title = result[2]
                    }

                    onReleased:{
                        l_card_shadow_radius = 15
                    }
                }

                Text{
                    anchors.fill:parent
                    font.pixelSize: 19
                    text:">"
                    horizontalAlignment: Text.AlignHCenter
                    color:main_color
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    Item{
        id:page_item
        anchors.fill:parent

        Rectangle {
            id: main_window_page
            anchors.margins:10
            anchors.fill:parent
            color: bgColor
            radius: 17
            opacity:o_val
            layer.enabled: true
            layer.smooth: true

            layer.effect: DropShadow {
                id:main_shadow
                transparentBorder: true
                samples: main_window.active? 40:30
                radius:  main_window.active? 20:15
                verticalOffset: 0
                color: "#60000000"

                Behavior on samples {NumberAnimation{duration: 200}}
                Behavior on radius  {NumberAnimation{duration: 200}}

            }
        }

        Rectangle{
            id:outline
            color:bgColor
            radius:15
            width:200
            height:600
            anchors.leftMargin: 10
            anchors.left: parent.left
            layer.enabled: true
            layer.smooth: true
            layer.effect: DropShadow {
                id:outline_shadow
                transparentBorder: true
                samples: 30
                radius: 15
                horizontalOffset: 3
                color: shadow_color

                Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
            }

            Item{
                id:img_item
                x:50
                y:30
                width:100
                height:100

                Behavior on scale {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutSine
                    }
                }

                Image {
                    id:img
                    source: mem.imgSymbol
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill:parent
                    smooth:true
                    visible:false
                    property bool isDragging: false
                    property bool isValid: false
                }

                Text{
                    id:drop_text
                    opacity:0
                    z:2
                    anchors.verticalCenter: img.verticalCenter
                    anchors.horizontalCenter: img.horizontalCenter
                    text:"Drop img here!"
                    color:main_color
                    visible: mem.img_changed === "F"

                    Behavior on opacity  {NumberAnimation{duration: 300}}
                }

                Rectangle{
                    id:img_mask
                    width:100
                    height:100
                    radius:50
                    visible:false

                }

                OpacityMask{
                    anchors.fill:img
                    source:img
                    maskSource:img_mask
                }

                Rectangle{
                    z:1
                    width: 100
                    height: 100
                    smooth:true
                    color:"transparent"
                    radius:50
                    border.color: symbol_color
                    border.width:2

                    MouseArea{
                        anchors.fill:parent
                        hoverEnabled: true

                        onEntered: {
                            drop_text.opacity = 1
                        }

                        onExited:{
                            drop_text.opacity = 0
                        }
                    }

                    DropArea{
                        anchors.fill:parent

                        property bool isValid : false
                        property bool isDragging : false

                        onEntered: (drag) => {
                                       if (!drag.hasUrls || !drag.urls || drag.urls.length !== 1) {
                                           drag.accepted = false
                                           return
                                       }

                                       const url = drag.urls[0].toString()
                                       const lowerPath = url.toLowerCase()

                                       const isAcceptableType = /\.(jpe?g|png|gif|bmp|tiff?|webp|svg|ico|heic|heif|avif)$/i.test(lowerPath)


                                       isValid = isAcceptableType
                                       isDragging = true

                                       if (isValid) {
                                           drag.acceptProposedAction()
                                           drop_vocab_area.scale = 1.2
                                       } else {
                                           drag.accepted = false
                                       }
                                   }


                        onExited: () => {
                                      isDragging = false
                                      isValid = false
                                      img_item.scale = 1.0
                                  }

                        onDropped: (drag) => {
                                       isDragging = false
                                       isValid = false

                                       if (drag.hasUrls && drag.urls.length === 1) {
                                           const url = drag.urls[0]
                                           const filePath = url.toString().replace("file:///", "").replace(/\//g, "\\")
                                           mem.imgSymbol = "file:///" + filePath
                                           mem.img_changed = "T"
                                       }
                                   }
                    }
                }
            }

            Rectangle{
                id: setting_button
                width:160
                height:45
                x:20
                y:200
                color: bgColor

                Text{
                    id:setting_button_text
                    text:"Setting"
                    color:"gray"
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    Behavior on color{ColorAnimation{duration:200}}
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        main_window.clean_button();
                        setting_button_text.color="#33d6ff";
                        isin_setting=true;
                        setting_page.visible=true
                        setting_page.opacity=0
                        s_opacityAnim.start()
                    }

                    onEntered:{setting_button_text.color="#33d6ff"}
                    onExited:{
                        if(!isin_setting) setting_button_text.color="gray"
                    }
                }

                NumberAnimation {
                    id: s_opacityAnim
                    target: setting_page
                    property: "opacity"
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Rectangle{
                id: creat_button
                x:20
                width:160
                height:45
                anchors.top:setting_button.bottom
                color: bgColor

                Text{
                    id:creat_button_text
                    text:"Create"
                    color:"#33d6ff"
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    Behavior on color{ColorAnimation{duration:200}}
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        main_window.clean_button();
                        creat_button_text.color="#33d6ff";
                        isin_creat=true;
                        creat_page.visible=true
                        creat_page.opacity=0
                        c_opacityAnim.start()
                    }

                    onEntered:{creat_button_text.color="#33d6ff"}
                    onExited:{
                        if(!isin_creat) creat_button_text.color="gray"
                    }
                }

                NumberAnimation {
                    id: c_opacityAnim
                    target: creat_page
                    property: "opacity"
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Rectangle{
                id: history_button
                x:20
                width:160
                height:45
                anchors.top:creat_button.bottom
                color: bgColor

                Text{
                    id:history_button_text
                    text:"History"
                    color:"gray"
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    Behavior on color{ColorAnimation{duration:200}}
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        main_window.clean_button();
                        history_button_text.color="#33d6ff";
                        isin_history=true;
                        history_page.visible=true
                        history_page.opacity=0
                        h_opacityAnim.start()
                    }

                    onEntered:{history_button_text.color="#33d6ff"}
                    onExited:{
                        if(!isin_history) history_button_text.color="gray"
                    }
                }

                NumberAnimation {
                    id: h_opacityAnim
                    target: history_page
                    property: "opacity"
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Rectangle{
                id: leave_button
                x:20
                y:500
                width:160
                height:45
                color: bgColor

                Text{
                    id:leave_button_text
                    text:"Leave"
                    color:"gray"
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    Behavior on color{ColorAnimation{duration:200}}
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        blur_minimizeAnimation.start()
                        minimizeAnimation.start()
                        help_window_minimizeAnimation.start()
                    }

                    onEntered:{leave_button_text.color="#33d6ff"}
                    onExited:{leave_button_text.color="gray"}

                    SequentialAnimation {
                        id: minimizeAnimation
                        running: false

                        ParallelAnimation {
                            NumberAnimation { target: page_item; property: "scale"; to: 0.1; duration: 150 }
                            NumberAnimation { target: page_item; property: "opacity"; to: 0; duration: 150 }
                        }

                        ScriptAction {script: main_window.close()}
                    }
                }
            }
        }

        Rectangle{
            id:setting_page
            width:800
            height:600
            x:210
            y:10
            color:"transparent"
            visible:false
            property Item rootPage: page_item

            Text{
                id:setting_title
                color:main_color
                text:"Setting"
                anchors.left:parent.left
                anchors.top:parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 70
                width:100
                height:40
                font.pixelSize: 28
            }

            Text{
                id:trans_text
                color:main_color
                text:"Window transparency:"
                width:200
                font.pixelSize: 18
                anchors.top:setting_title.bottom
                anchors.topMargin: 50
                x:20
            }

            Item{
                id:o_slider
                width:300
                height:14
                anchors.left:trans_text.right
                anchors.top:setting_title.bottom
                anchors.topMargin: 56

                Rectangle{
                    width:300
                    height:6
                    radius:3
                    anchors.centerIn: parent
                    color:"#e0e0e0"
                }

                Rectangle{
                    id:handle
                    x:mem.my_opacity
                    z:1
                    width:16
                    height:16
                    radius:8
                    color:"#33d6ff"
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        property bool isDragging: false
                        property real x_pos: 0

                        onEntered: handle.scale = 1.1
                        onExited:  handle.scale = 1.0

                        onPressed: {
                            isDragging = true
                            x_pos=mouse.x

                        }

                        onReleased: {
                            isDragging = false
                        }


                        onMouseXChanged: {
                            if (isDragging) {
                                var deltaX = mouse.x - x_pos
                                mem.my_opacity = Math.max(0, Math.min(300,handle.x+deltaX))
                            }
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.InOutSine
                        }
                    }
                }
                Rectangle {
                    width: handle.x+2
                    height: 6
                    radius: 3
                    color: "#4d4dff"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }
            }

            Text{
                id:blur_text
                text:"Blur:"
                width:60
                font.pixelSize: 18
                anchors.top: trans_text.bottom
                anchors.topMargin: 10
                x: 20
                color:main_color
            }

            Item{
                id:b_slider
                width:300
                height:14
                anchors.left:blur_text.right
                anchors.top:trans_text.bottom
                anchors.topMargin: 15

                Rectangle{
                    width:300
                    height:6
                    radius:3
                    anchors.centerIn: parent
                    color:"#e0e0e0"
                }

                Rectangle{
                    id:b_handle
                    x:mem.my_blur
                    z:1
                    width:16
                    height:16
                    radius:8
                    color:"#33d6ff"
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        property bool isDragging: false
                        property real x_pos: 0

                        onEntered: b_handle.scale = 1.1
                        onExited:  b_handle.scale = 1.0

                        onPressed: {
                            isDragging = true
                            x_pos=mouse.x

                        }

                        onReleased: {
                            isDragging = false
                        }


                        onMouseXChanged: {
                            if (isDragging) {
                                var deltaX = mouse.x - x_pos
                                mem.my_blur = Math.max(0, Math.min(300,b_handle.x+deltaX))
                            }
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.InOutSine
                        }
                    }
                }
                Rectangle {
                    width: b_handle.x+2
                    height: 6
                    radius: 3
                    color: "#4d4dff"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }
            }

            Text{
                id:theme_text
                text:"Theme color:"
                width:200
                font.pixelSize: 18
                anchors.topMargin: 20
                anchors.top: b_slider.bottom
                color:main_color
                x:20
            }

            Item{
                id:theme_area
                anchors.topMargin: 20
                anchors.top:theme_text.bottom
                x:40
                width:700
                height:100

                Item{
                    id:white_theme_item
                    width:104
                    height:64

                    Rectangle{
                        id:m_white_border
                        anchors.fill:parent
                        color:"blue"
                        radius:10
                    }

                    Rectangle{
                        id:m_white
                        width:100
                        height:60
                        color:"#ebebeb"
                        radius:10
                        anchors.top:parent.top
                        anchors.topMargin: 2
                        anchors.left:parent.left
                        anchors.leftMargin: 2
                        layer.enabled: true
                        layer.smooth: true
                        layer.effect: DropShadow {
                            id:white_theme_shadow
                            transparentBorder: true
                            samples: 60
                            radius: w_shadow_radius
                            horizontalOffset: 3
                            color: special_shadow_color

                            Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                            Behavior on radius{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                        }

                        Rectangle{
                            anchors.top:parent.top
                            width:30
                            height:60
                            radius:10
                            color:"white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                white_theme_item.scale = 1.03
                                w_shadow_radius = 35
                            }
                            onExited: {
                                white_theme_item.scale = 1.0
                                w_shadow_radius = 25
                            }

                            onClicked: {
                                clean_theme_border();
                                m_white_border.visible=true
                                set_theme(1)
                                mem.my_theme = 1
                                syncColorChange.start()
                                submit_syncColorChange.start()

                            }
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.InOutSine
                        }
                    }
                }


                Item{
                    id:black_theme_item
                    width:104
                    height:64
                    anchors.leftMargin: 20
                    anchors.left:white_theme_item.right

                    Rectangle{
                        id:m_black_border
                        anchors.fill:parent
                        width:104
                        height:64
                        color:"blue"
                        radius:10
                    }

                    Rectangle{
                        id:m_black
                        width:100
                        height:60
                        color:"#484f50"
                        radius:10
                        anchors.top:parent.top
                        anchors.topMargin: 2
                        anchors.left:parent.left
                        anchors.leftMargin: 2
                        layer.enabled: true
                        layer.smooth: true
                        layer.effect: DropShadow {
                            id:black_theme_shadow
                            transparentBorder: true
                            samples: 60
                            radius: b_shadow_radius
                            horizontalOffset: 3
                            color: special_shadow_color

                            Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                            Behavior on radius{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                        }

                        Rectangle{
                            anchors.top:parent.top
                            width:30
                            height:60
                            radius:10
                            color:"black"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                black_theme_item.scale = 1.03
                                b_shadow_radius = 35
                            }
                            onExited: {
                                black_theme_item.scale = 1.0
                                b_shadow_radius = 25
                            }

                            onClicked: {
                                clean_theme_border();
                                m_black_border.visible=true
                                set_theme(2)
                                mem.my_theme = 2
                                syncColorChange.start()
                            }
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.InOutSine
                        }
                    }
                }
            }

            Rectangle {
                id: clean_data_button
                anchors.top: theme_area.bottom
                anchors.topMargin: 10
                x: 20
                scale: 1
                width: 100
                height: 40
                radius: 10
                border.width: 1.5
                color: bgColor
                border.color: main_color
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 50
                    radius: help_button_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 100}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                Text {
                    anchors.fill: parent
                    font.pixelSize: 14
                    text: "Clean Data"
                    horizontalAlignment: Text.AlignHCenter
                    color: main_color
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: clean_data_button.scale = 1.03
                    onExited: clean_data_button.scale = 1.0
                    onPressed: {
                        mem.deleteFile("C:/Vocab/setting.json")
                    }
                }
                Behavior on scale  {NumberAnimation{duration: 200}}

                PropertyAnimation {
                    id: animateBorder
                    target: clean_data_button
                    property: "border.color"
                    to: newMainColor
                    duration: 300
                    easing.type: Easing.InOutSine
                }

                PropertyAnimation {
                    id: animateBg
                    target: clean_data_button
                    property: "color"
                    to: newBgColor
                    duration: 300
                    easing.type: Easing.InOutSine
                }

                ParallelAnimation {
                    id: syncColorChange
                    animations: [animateBorder, animateBg]
                }
            }

        }

        Rectangle{
            id:creat_page
            width:800
            height:600
            x:210
            y:10
            color:"transparent"
            visible:true
            property Item rootPage: page_item

            Window {
                id: help_window
                width: 300
                height: 200
                title: "Help"
                visible: false
                modality: Qt.NonModal
                color: "transparent"
                flags: Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

                Rectangle {
                    id: rootRect
                    anchors.fill: parent
                    color: bgColor
                    radius: 9

                    MouseArea {
                        id: bgDrag
                        anchors.fill: parent
                        hoverEnabled: false

                        onPressed: function(mouse) {
                            if (help_window_leave_button.containsMouse) {
                                mouse.accepted = false;
                                return;
                            }
                            if (mouse.button === Qt.LeftButton) help_window.startSystemMove();

                        }
                    }

                    Rectangle {
                        id: help_window_leave_button
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 4
                        anchors.rightMargin: 4
                        width: 18
                        height: 18
                        radius: width/2
                        color: "red"

                        MouseArea {
                            id: btnMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing: true
                            onClicked: function() {
                                help_window_minimizeAnimation.start()
                            }
                            onEntered: help_window_leave_button.color = "#ff7073"
                            onExited:  help_window_leave_button.color = "red"
                        }

                        Behavior on color{ColorAnimation { duration: 300;easing.type: Easing.InOutSine}}

                        SequentialAnimation {
                            id: help_window_minimizeAnimation
                            running: false
                            ParallelAnimation {
                                NumberAnimation { target: rootRect; property: "scale"; to: 0.1; duration: 150 }
                                NumberAnimation { target: rootRect; property: "opacity"; to: 0; duration: 150 }
                            }

                            ScriptAction {
                                script: {
                                    help_window.close()
                                    help_blurEffect.enabled = false
                                }
                            }
                        }

                        SequentialAnimation {
                            id: help_window_minimizeAnimation_open
                            running: false

                            ScriptAction {
                                script: {
                                    help_window.show();
                                    help_blurEffect.window = help_window
                                    help_blurEffect.enabled = true
                                }
                            }

                            ParallelAnimation {
                                NumberAnimation { target: rootRect; property: "scale"; to: 1; duration: 150 }
                                NumberAnimation { target: rootRect; property: "opacity"; to: 0.6; duration: 150 }
                            }
                        }
                    }

                    Text{
                        id:help_title
                        anchors.top:parent.top
                        anchors.topMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 18
                        text:"How to create a form"
                        color:main_color
                    }

                    Text{
                        id:help_line_one
                        x:15
                        anchors.top:help_title.bottom
                        anchors.topMargin: 10
                        font.pixelSize: 14
                        color:main_color
                        text:"Replace the special part in your"
                    }

                    Text{
                        id:help_line_two
                        x:15
                        anchors.top:help_line_one.bottom
                        anchors.topMargin: 5
                        font.pixelSize: 14
                        color:main_color
                        text:"vocab&meaning. Example:"
                    }

                    Text{
                        id:help_line_three
                        x:15
                        anchors.top:help_line_two.bottom
                        anchors.topMargin: 13
                        font.pixelSize: 14
                        color:main_color
                        text:"1.Hello:greet -> (num).(vocab):(meaning)"
                    }

                    Text{
                        id:help_line_four
                        x:15
                        anchors.top:help_line_three.bottom
                        anchors.topMargin: 5
                        font.pixelSize: 14
                        color:main_color
                        text:"1.Hello-greet -> (num).(vocab)-(meaning)"
                    }

                    Text{
                        id:help_line_five
                        anchors.top:help_line_four.bottom
                        anchors.topMargin: 20
                        x:120
                        font.pixelSize: 14
                        color:main_color
                        text:"DON'T IGNORE SPACE!!!"
                        font.bold: true
                    }
                }
            }

            Text{
                id:creat_title
                color:main_color
                text:"Create"
                anchors.left:parent.left
                anchors.top:parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 70
                width:100
                height:40
                font.pixelSize: 28
            }

            Text{
                id:input_title
                color:main_color
                text:"Title:"
                width:49
                font.pixelSize: 18
                anchors.top:creat_title.bottom
                anchors.topMargin: 50
                x:20
            }

            TextField {
                id: title_field
                anchors.top:creat_title.bottom
                anchors.topMargin: 50
                anchors.left:input_title.right
                color:main_color
                width: 200
                height:25
                font.pixelSize: 15
                placeholderText: ""
                placeholderTextColor: "red"

                onFocusChanged: {
                    if (focus) title_shadow_radius = 15
                    else title_shadow_radius = 10;
                }

                background:Rectangle{
                    radius:5
                    color:bgColor
                    border.color:main_color
                    border.width:2
                }

                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    id:title_shadow
                    transparentBorder: true
                    samples: 30
                    radius: title_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 200}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

            }

            Text{
                id:input_form
                color:main_color
                text:"Form:"
                width:49
                font.pixelSize: 18
                anchors.top:creat_title.bottom
                anchors.topMargin: 50
                anchors.left:title_field.right
                anchors.leftMargin: 65
            }

            TextField {
                id: form_field
                anchors.top:creat_title.bottom
                anchors.topMargin: 50
                anchors.left:input_form.right
                anchors.leftMargin: 9
                color:main_color
                width: 200
                height:25
                font.pixelSize: 15
                placeholderText: ""
                placeholderTextColor: "red"

                background:Rectangle{
                    radius:5
                    color:bgColor
                    border.color:main_color
                    border.width:2
                }

                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    id:form_shadow
                    transparentBorder: true
                    samples: 30
                    radius: form_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 200}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                onFocusChanged: {
                    if (focus) form_shadow_radius = 15
                    else form_shadow_radius = 10;

                }
            }

            Rectangle{
                id:help_button
                height:20
                width:20
                radius:10
                anchors.topMargin: 52.5
                anchors.top:creat_title.bottom
                anchors.left:form_field.right
                anchors.leftMargin: 8
                color:bgColor
                border.color:main_color
                border.width:1.5
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 50
                    radius: help_button_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 100}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered:{help_button_shadow_radius = 15}
                    onExited: {help_button_shadow_radius = 13}
                    onPressed:{
                        help_button_shadow_radius = 0
                        help_window.visible = true
                        help_window_minimizeAnimation_open.start()
                    }

                    onReleased:{help_button_shadow_radius = 15}
                }

                Text{
                    anchors.fill:parent
                    font.pixelSize: 15
                    text:"?"
                    horizontalAlignment: Text.AlignHCenter
                    color:main_color
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle{
                    id:drop_file
                    anchors.top:form_field.bottom
                    anchors.topMargin: 30

                }
            }

            Rectangle{
                id:drop_vocab_area
                anchors.top :form_field.bottom
                anchors.topMargin: 100
                x:250
                width: 150
                height:150
                radius:15
                color:bgColor
                border.color:main_color
                border.width:2
                layer.enabled: true
                layer.smooth: true

                Behavior on scale {NumberAnimation{duration: 300}}
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 30
                    radius: drop_shadow_radius
                    color: special_shadow_color
                    Behavior on radius {NumberAnimation{duration: 300}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                SequentialAnimation on border.color {
                    id:infinite_anim
                    loops: Animation.Infinite
                    ColorAnimation { to: bgColor; duration: 3000 }
                    ColorAnimation { to: main_color; duration: 3000 }
                }

                SequentialAnimation {
                    id: wrong_hit
                    loops: 1

                    ScriptAction {
                        script: {
                            infinite_anim.stop()
                        }
                    }

                    PropertyAnimation {
                        target: drop_vocab_area
                        property: "border.color"
                        to: "red"
                        duration: 100
                    }

                    SequentialAnimation {
                        loops: 4
                        RotationAnimation {
                            target: drop_vocab_area
                            property: "rotation"
                            from: 0; to: -5; duration: 60
                            easing.type: Easing.OutCubic
                        }
                        RotationAnimation {
                            target: drop_vocab_area
                            property: "rotation"
                            from: -5; to: 5; duration: 60
                            easing.type: Easing.OutCubic
                        }
                        RotationAnimation {
                            target: drop_vocab_area
                            property: "rotation"
                            from: 5; to: 0; duration: 60
                            easing.type: Easing.OutCubic
                        }
                    }

                    PropertyAnimation {
                        target: drop_vocab_area
                        property: "border.color"
                        to: drop_vocab_area.bgColor
                        duration: 200
                    }

                    ScriptAction {
                        script: {
                            infinite_anim.start()
                        }
                    }
                }


                SequentialAnimation {
                    id: right_hit
                    loops: 1

                    ScriptAction {
                        script: {
                            infinite_anim.stop()
                            drop_vocab_area.border.color = "green"
                        }
                    }

                    PauseAnimation { duration: 800 }

                    ScriptAction {
                        script: {
                            infinite_anim.start()
                        }
                    }
                }


                Behavior on border.color{ColorAnimation {duration: 800}}

                Text{
                    id:drop_hit
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:main_color
                    text:"Drop File Here"
                    font.pixelSize: 18
                    opacity:0

                    Behavior on opacity{NumberAnimation{duration: 400}}
                }

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true

                    onEntered:if(handleinfo.getPath() === "")drop_hit.opacity = 1
                    onExited: if(handleinfo.getPath() === "")drop_hit.opacity = 0
                }

                DropArea{
                    anchors.fill:parent

                    property bool isValid : false
                    property bool isDragging : false

                    onEntered: (drag) => {
                                   if (!drag.hasUrls || !drag.urls || drag.urls.length !== 1) {
                                       drag.accepted = false
                                       return
                                   }

                                   const url = drag.urls[0].toString()
                                   const lowerPath = url.toLowerCase()

                                   const isAcceptableType = /\.(txt|docx?|pdf|csv|md|odt)$/i.test(lowerPath)

                                   isValid = isAcceptableType
                                   isDragging = true

                                   if (isValid) {
                                       drag.acceptProposedAction()
                                       drop_vocab_area.scale = 1.03
                                   } else {drag.accepted = false}

                               }



                    onExited: () => {
                                  isDragging = false
                                  isValid = false
                                  drop_vocab_area.scale = 1.0
                              }

                    onDropped: (drag) => {
                                   isDragging = false
                                   isValid = false

                                   if (drag.hasUrls && drag.urls.length === 1) {
                                       const url = drag.urls[0]
                                       handleinfo.setPath(url.toString())
                                       handleinfo.getRes()
                                       right_hit.start()
                                   }
                               }
                }
            }

            Rectangle {
                id: submit_button
                anchors.top: drop_vocab_area.bottom
                anchors.topMargin: 50
                x: 20
                scale: 1
                width: 100
                height: 40
                radius: 10
                border.width: 1.5
                color: bgColor
                border.color: main_color
                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 50
                    radius: help_button_shadow_radius
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 100}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                Behavior on scale  {NumberAnimation{duration: 300;easing:Easing.InOutQuad }}

                Text {
                    anchors.fill: parent
                    font.pixelSize: 14
                    text: "Create"
                    horizontalAlignment: Text.AlignHCenter
                    color: main_color
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {//duandian
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: submit_button.scale = 1.03
                    onExited: submit_button.scale = 1.0
                    onClicked: {
                        title_field.placeholderText = ""
                        form_field.placeholderText = ""

                        if ( title_field.text === "") title_field.placeholderText = "Please input title"

                        if ( form_field.text === "") form_field.placeholderText = "Please input form"

                        if (handleinfo.getPath() === "") wrong_hit.start()


                        if(!handleinfo.checkForm(form_field.text)){
                            form_field.clear()
                            form_field.placeholderText = "Error form"
                            return;
                        }

                        handleinfo.setTitle(title_field.text)
                        handleinfo.setForm(form_field.text)
                        handleinfo.creatForm()
                        handleinfo.generateFilePath()
                        handleinfo.generateJsonFile()

                        title_field.clear()
                        form_field.clear()

                        start_vocab_window()
                    }
                }
            }

            PropertyAnimation {
                id: submit_animateBorder
                target: clean_data_button
                property: "border.color"
                to: newMainColor
                duration: 300
                easing.type: Easing.InOutSine
            }

            PropertyAnimation {
                id: submit_animateBg
                target: clean_data_button
                property: "color"
                to: newBgColor
                duration: 300
                easing.type: Easing.InOutSine
            }

            ParallelAnimation {
                id: submit_syncColorChange
                animations: [submit_animateBorder, submit_animateBg]
            }
        }

    }

    Rectangle{
        id:history_page
        width:800
        height:600
        x:210
        y:10
        color:"transparent"
        visible:false
        property Item rootPage: page_item

        Text{
            id:history_title
            color:main_color
            text:"History"
            anchors.left:parent.left
            anchors.top:parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 70
            width:100
            height:40
            font.pixelSize: 28
        }

        Repeater {
            model: files_info.length

            Rectangle {
                width: 650
                height: 60
                color: bgColor
                radius:13
                anchors.left:parent.left
                y:80 + 75*index
                anchors.leftMargin: 40
                border.color:main_color
                border.width: 2

                layer.enabled: true
                layer.smooth: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    samples: 30
                    radius: hoveredIndex === index ? 15 : (hoveredIndex === -2 ? 0 : 10)
                    color: special_shadow_color
                    Behavior on radius  {NumberAnimation{duration: 200}}
                    Behavior on color{ColorAnimation { duration: 300; easing.type: Easing.InOutSine }}
                }

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent

                    onEntered: hoveredIndex = index
                    onExited: hoveredIndex = -1
                    onClicked: {
                        hoveredIndex = -2
                        handleinfo.setPath(files_info[index].path)
                        handleinfo.load_card()
                        start_vocab_window()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: files_info[index].name
                    color:main_color
                }
            }
        }
    }

}
/***
    *               ii.                                         ;9ABH,
    *              SA391,                                    .r9GG35&G
    *              &#ii13Gh;                               i3X31i;:,rB1
    *              iMs,:,i5895,                         .5G91:,:;:s1:8A
    *               33::::,,;5G5,                     ,58Si,,:::,sHX;iH1
    *                Sr.,:;rs13BBX35hh11511h5Shhh5S3GAXS:.,,::,,1AG3i,GG
    *                .G51S511sr;;iiiishS8G89Shsrrsh59S;.,,,,,..5A85Si,h8
    *               :SB9s:,............................,,,.,,,SASh53h,1G.
    *            .r18S;..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,....,,.1H315199,rX,
    *          ;S89s,..,,,,,,,,,,,,,,,,,,,,,,,....,,.......,,,;r1ShS8,;Xi
    *        i55s:.........,,,,,,,,,,,,,,,,.,,,......,.....,,....r9&5.:X1
    *       59;.....,.     .,,,,,,,,,,,...        .............,..:1;.:&s
    *      s8,..;53S5S3s.   .,,,,,,,.,..      i15S5h1:.........,,,..,,:99
    *      93.:39s:rSGB@A;  ..,,,,.....    .SG3hhh9G&BGi..,,,,,,,,,,,,.,83
    *      G5.G8  9#@@@@@X. .,,,,,,.....  iA9,.S&B###@@Mr...,,,,,,,,..,.;Xh
    *      Gs.X8 S@@@@@@@B:..,,,,,,,,,,. rA1 ,A@@@@@@@@@H:........,,,,,,.iX:
    *     ;9. ,8A#@@@@@@#5,.,,,,,,,,,... 9A. 8@@@@@@@@@@M;    ....,,,,,,,,S8
    *     X3    iS8XAHH8s.,,,,,,,,,,...,..58hH@@@@@@@@@Hs       ...,,,,,,,:Gs
    *    r8,        ,,,...,,,,,,,,,,.....  ,h8XABMMHX3r.          .,,,,,,,.rX:
    *   :9, .    .:,..,:;;;::,.,,,,,..          .,,.               ..,,,,,,.59
    *  .Si      ,:.i8HBMMMMMB&5,....                    .            .,,,,,.sMr
    *  SS       :: h@@@@@@@@@@#; .                     ...  .         ..,,,,iM5
    *  91  .    ;:.,1&@@@@@@MXs.                            .          .,,:,:&S
    *  hS ....  .:;,,,i3MMS1;..,..... .  .     ...                     ..,:,.99
    *  ,8; ..... .,:,..,8Ms:;,,,...                                     .,::.83
    *   s&: ....  .sS553B@@HX3s;,.    .,;13h.                            .:::&1
    *    SXr  .  ...;s3G99XA&X88Shss11155hi.                             ,;:h&,
    *     iH8:  . ..   ,;iiii;,::,,,,,.                                 .;irHA
    *      ,8X5;   .     .......                                       ,;iihS8Gi
    *         1831,                                                 .,;irrrrrs&@
    *           ;5A8r.                                            .:;iiiiirrss1H
    *             :X@H3s.......                                .,:;iii;iiiiirsrh
    *              r#h:;,...,,.. .,,:;;;;;:::,...              .:;;;;;;iiiirrss1
    *             ,M8 ..,....,.....,,::::::,,...         .     .,;;;iiiiiirss11h
    *             8B;.,,,,,,,.,.....          .           ..   .:;;;;iirrsss111h
    *            i@5,:::,,,,,,,,.... .                   . .:::;;;;;irrrss111111
    *            9Bi,:,,,,......                        ..r91;;;;;iirrsss1ss1111
    * 狗头护体
    */
