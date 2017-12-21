pragma Singleton

import QtQuick 2.0

import "."

QdObject {
    id: app

    property string name: "QtFirebase Example"

    property bool debugging: debugBuild

    readonly property bool active: Qt.application.state === Qt.ApplicationActive // Qt.application.active

    property alias versions: versions
    QtObject {
        id: versions
        readonly property string qt: qtVersion
        readonly property string app: version
        readonly property string git: gitVersion
        readonly property string branch: gitBranch
        readonly property string firebase: qtFirebaseVersion
        readonly property string firebaseGit: qtFirebaseGitVersion
        readonly property string firebaseGitBranch: qtFirebaseGitBranch

    }

    QdObject {
        id: internal

        // NOTE HACK 'setTimeout' function based on Timer
        Component { id: timerComponent; Timer {} }
        function setTimeout(callback, timeout)
        {
            var timer = timerComponent.createObject(internal)
            timer.interval = timeout || 0
            timer.triggered.connect(function()
            {
                timer.stop()
                timer.destroy()
                timer = null
                callback()
            })
            timer.start()
            return timer
        }
    }

    function setTimeout(callback, timeout)
    {
        return internal.setTimeout(callback, timeout)
    }

    function toConsoleHistory() {
        var args = Array.prototype.slice.call(arguments), i
        for(i in args) {
            consoleHistory += args[i].toString()+"\n"
        }
    }

    property string consoleHistory: ""
    property string logPrefix: "QtFirebaseExample"

    function log() {
        var args = Array.prototype.slice.call(arguments)
        toConsoleHistory(args)
        args.unshift(logPrefix+" LOG")
        console.log.apply(console, args)
    }

    function error() {
        var args = Array.prototype.slice.call(arguments)
        toConsoleHistory(args)
        args.unshift(logPrefix+" ERROR")
        console.error.apply(console, args)
    }

    function debug() {
        var args = Array.prototype.slice.call(arguments)
        toConsoleHistory(args)
        args.unshift(logPrefix+" DEBUG")
        console.debug.apply(console, args)
    }

    function warn() {
        var args = Array.prototype.slice.call(args)
        toConsoleHistory(args)
        args.unshift(logPrefix+" WARNING")
        console.warn.apply(console, args)
    }

    function info() {
        var args = Array.prototype.slice.call(arguments)
        toConsoleHistory(args)
        args.unshift(logPrefix+" INFO")
        console.info.apply(console, args)
    }

}
