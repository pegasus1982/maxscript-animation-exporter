rollout AnimationExporter "Animation Exporter"
(
    -- rollout ui
    groupBox group_targets "Targets" \
        pos:[10, 10] \
        width: 300 \
        height: 85
    checkbutton btn_PickCamera "Pick Camera" \
        pos:[22, 32] \
        width:100
    edittext edit_TargetCamera "" \
        pos:[130, 34] \
        width:170

    checkbutton btn_PickObject "Pick Object" \
        pos:[22, 62] \
        width:100
    edittext edit_TargetObject "" \
        pos:[130, 64] \
        width:170

    groupBox group_TimeFrame "Time Frames" \
        pos:[10, 110] \
        width: 300 \
        height: 80
    radiobuttons radio_FrameType \
        labels:#("Active Time Segment", "Range") \
        offsets:#([0,0], [0,15]) 
        pos:[22, 130] \
        columns:1
    spinner spin_TimeFrom "From" \
        type:#integer \
        pos:[110, 162] \
        width:50
    spinner spin_TimeTo "To" \
        type:#integer \
        pos:[200, 162] \
        width:50
    groupBox group_ExportOptions "Export Options" \
        pos:[10, 200] \
        width: 300 \
        height: 105
    checkbox check_ExportPosition "Position" \
        pos:[22, 220]
    checkbox check_ExportOrientation "Orientation" \
        pos:[22, 240]
    checkbox check_ExportDistance "Distance" \
        pos:[22, 260]
    checkbox check_ExportPerpendicular "Perpendicular Value" \
        pos:[22, 280]

    button btn_Export "Export" \
        pos:[80, 320] \
        width:160 \
        height:30
    -- end rollout ui
)

createdialog AnimationExporter width:320 height:370