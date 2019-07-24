rollout CustomAnimationExporter "Custom Animation Exporter"
(
    -- rollout ui
    groupBox group_targets "Targets" pos:[10, 10] width: 300 height: 85
    checkbutton btn_PickCamera "Pick Camera" pos:[22, 32] width:100
    edittext edit_TargetCamera "" pos:[130, 34] width:170

    checkbutton btn_PickSurface "Pick Surface" pos:[22, 62] width:100
    edittext edit_TargetSurface "" pos:[130, 64] width:170

    groupBox group_TimeFrame "Time Frames" pos:[10, 110] width: 300 height: 80
    radiobuttons radio_FrameType labels:#("Active Time Segment", "Range") offsets:#([0,0], [0,15]) pos:[22, 130] columns:1
    label text_ActiveTimeSeg "0 to " pos:[160, 132]
    spinner spin_TimeFrom "From" type:#integer pos:[110, 162] width:50
    spinner spin_TimeTo "To" type:#integer pos:[200, 162] width:50
    groupBox group_ExportOptions "Export Options" pos:[10, 200] width: 300 height: 105
    checkbox check_ExportPosition "Position" pos:[22, 220]
    checkbox check_ExportOrientation "Orientation" pos:[22, 240]
    checkbox check_ExportDistance "Distance" pos:[22, 260]
    checkbox check_ExportPerpendicular "Perpendicular Value" pos:[22, 280]

    button btn_Export "Export" pos:[80, 320] width:160 height:30
    -- end rollout ui

    global target_Surface
    global target_Camera

    fn getTimeRange = (
        local range = #(0, 100)
        return range
    )
    fn getPosition = (
        local obj = target_Camera
        return obj.pos
    )

    fn getDir = (
        local obj = target_Camera
        return obj.dir
    )

    fn getDistance = (
        obj = target_Surface
        cam = target_Camera
        dir = cam.dir
        
        testRay = Ray cam.pos (cam.dir * [-1, -1, -1])
        i = intersectRay target_Surface testRay
        if (i != undefined) then (

            return distance cam.pos i.pos
        ) else (
            return -1
        )
    )
    -- export button press event
    on btn_Export pressed do (
        print "export button pressed"
        local timeRange = getTimeRange()
        local timeStart = timeRange[1]
        local timeEnd = timeRange[2]
        local i = 0
        with animate on (
            for i = timeStart to timeEnd do (
                at time i (
                    local pos = getPosition()
                    local dir = getDir()
                    local dist = getDistance()
                    format "time : %\npos : %\ndir : %\ndistance : %\n\n" i pos dir dist
                )
            )
        )
    )
    -- end export button press event

    on btn_PickCamera changed state do (
        if state == true do (
            try (
                target_Camera = pickobject propt:"Pick Camera"
                edit_TargetCamera.text = target_Camera.name
                btn_PickCamera.checked = false;
            ) catch ()
        )
    )

    on btn_PickSurface changed state do (
        if state == true do (
            try (
                target_Surface = pickobject propt:"Pick surface"
                edit_TargetSurface.text = target_Surface.name
                btn_PickSurface.checked = false;
            ) catch ()
        )
    )

    on CustomAnimationExporter open do (
        print "animation exporter opened"
        local endFrame = animationrange.end.frame as integer;
        text_ActiveTimeSeg.text = "0 to "+(endFrame as string)
        spin_TimeFrom.range = [0, endFrame, 0]
        spin_TimeTo.range = [0, endFrame, endFrame]
    )
)

createdialog CustomAnimationExporter width:320 height:370