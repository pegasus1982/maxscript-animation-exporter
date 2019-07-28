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
    checkbox check_ExportPosition "Position" pos:[22, 220] checked:true
    checkbox check_ExportOrientation "Orientation" pos:[22, 240] checked:true
    checkbox check_ExportDistance "Distance" pos:[22, 260] checked:true
    checkbox check_ExportPerpendicular "Perpendicular Value" pos:[22, 280] checked:true

    button btn_Export "Export" pos:[80, 320] width:160 height:30
    -- end rollout ui

    global target_Surface
    global target_Camera

    fn getTimeRange = (
        local endFrame = animationrange.end.frame as integer;
        if (radio_FrameType.state == 1) then (
            return [0, endFrame]
        ) else (
            return [0, spin_TimeTo.value]
        )
    )
    fn getPosition = (
        local obj = target_Camera
        return obj.pos
    )

    fn getDir = (
        local obj = target_Camera
        local dir = [acos obj.dir[1], acos obj.dir[2], acos obj.dir[3]]
        return dir
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
            return undefined
        )
    )

    fn getPerpendicularValue = (
        obj = target_Surface
        cam = target_Camera
        dir = cam.dir
        
        testRay = Ray cam.pos (cam.dir * [-1, -1, -1])
        i = intersectRay target_Surface testRay
        if (i != undefined) then (
            diff = i.dir - dir
            return [(asin diff[1]), (asin diff[2]), (asin diff[3])]
        ) else (
            return undefined
        )
    )

    fn saveAsFile data = (
        local cnt = data.count
        local fileName = target_Surface.name + "-output.csv"
        print fileName
        try(
            out_file = createFile fileName
            format "position X, position Y, position Z, orientation X, orientation Y, orientation Z, distance, angle X, angle Y, angle Z\n" to:out_file
            
            for i = 1 to cnt do (
                format "%, %, %, %, %, %, %, %, %, %\n" data[i][1][1] data[i][1][2] data[i][1][3] data[i][2][1] data[i][2][2] data[i][2][3] data[i][3] data[i][4][1] data[i][4][2] data[i][4][3] to:out_file
            )

            close out_file
            messageBox "Exporting Result Successed" title:"Info"
        ) catch (
            messageBox "Can't create output file" title:"Error"
        )
    )
    -- export button press event
    on btn_Export pressed do (
        print "export button pressed"
        local timeRange = getTimeRange()
        print timeRange
        local timeStart = timeRange[1]
        local timeEnd = timeRange[2]
        local i = 0
        local exportValues = #()
        with animate on (
            for i = timeStart to timeEnd do (
                at time i (
                    local pos
                    local dir
                    local dist
                    local perpendicular

                    if (check_ExportPosition.checked == true) do pos = getPosition()
                    if (check_ExportOrientation.checked == true) do dir = getDir()
                    if (check_ExportDistance.checked == true) do dist = getDistance()
                    if (check_ExportPerpendicular.checked == true) do perpendicular = getPerpendicularValue()
                    append exportValues #(pos, dir, dist, perpendicular)
                )
            )
        )

        saveAsFile(exportValues)
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