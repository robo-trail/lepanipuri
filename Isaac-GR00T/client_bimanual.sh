python examples/SO-100/eval_lerobot.py \
    --robot.type=bi_so100_follower \
    --robot.right_arm_port=/dev/ttySLLF \
    --robot.left_arm_port=/dev/ttySLRF \
    --robot.id=follower \
    --robot.cameras='{left: {"type": "opencv", "index_or_path":/dev/video2, "width": 640, "height": 480, "fps": 30}, right: {"type": "opencv", "index_or_path": /dev/video0, "width": 640, "height": 480, "fps": 30}, top: {"type": "intelrealsense", "serial_number_or_name": "827312071236", "width": 640, "height": 480, "fps": 30},}' \
    --policy_host=0.0.0.0 \
    --lang_instruction="pick up a puri with the left arm, place it on the plate, then poke a hole in it with the right arm."
