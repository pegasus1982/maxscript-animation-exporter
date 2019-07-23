rollout AnimationExporter "Animation Exporter"
(
    -- rollout ui
    groupBox group_targets "Targets" \
        pos:[10, 10] \
        width: 300 \
        height: 90
    checkbutton btn_PickCamera "Pick Camera" \
        pos:[22, 32] \
        width:100
    edittext edit_TargetCamera "" \
        pos:[130, 35] \
        width:170

    checkbutton btn_PickObject "Pick Object" \
        pos:[22, 62] \
        width:100
    edittext edit_TargetObject "" \
        pos:[130, 65] \
        width:170

    groupBox group_TimeFrame "TimeFrames" \
        pos:[10, 110] \
        width: 300 \
        height: 80
    radiobuttons radio_FrameType \
        labels:#("Active Time Segment", "Range") \
        offsets:#([0,0], [0,15]) 
        pos:[22, 130] \
        columns:1
    -- end rollout ui
)

createdialog AnimationExporter width:320 height:400