import QtQuick 2.0

Item {
    id: r
    width: app.fs*3
    height: width
    property int numSign: -1
    Rectangle{
        anchors.fill: r
        radius: app.fs*0.25
        color: 'black'
        border.width: app.fs*0.1
        border.color: 'white'
        Image {
            id: sign
            source: "./imgs/signos/"+r.numSign+".png"
            width: r.width
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }
    }
}
