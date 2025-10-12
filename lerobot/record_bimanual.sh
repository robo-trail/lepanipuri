lerobot-record \
    --robot.type=bi_so100_follower \
    --robot.left_arm_port=/dev/ttySLLF \
    --robot.right_arm_port=/dev/ttySLRF \
    --robot.id=follower \
    --robot.cameras='{
    left: {"type": "opencv", "index_or_path": /dev/video2, "width": 640, "height": 480, "fps": 30},
    right: {"type": "opencv", "index_or_path": /dev/video0, "width": 640, "height": 480, "fps": 30},
    top: {"type": "intelrealsense", "serial_number_or_name": "827312071236", "width": 640, "height": 480, "fps": 30},
    }' \
    --teleop.type=bi_so100_leader \
    --teleop.left_arm_port=/dev/ttySLLL \
    --teleop.right_arm_port=/dev/ttySLRL \
    --teleop.id=leader \
    --display_data=true \
    --dataset.repo_id=agro/pp \
    --dataset.root=record-rs \
    --dataset.num_episodes=2 \
    --dataset.episode_time_s=30 \
    --dataset.single_task="Prepare panipuri"
