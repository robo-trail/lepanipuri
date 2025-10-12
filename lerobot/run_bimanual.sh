lerobot-teleoperate \
    --robot.type=bi_so101_follower \
    --robot.left_arm_port=/dev/ttySLLF \
    --robot.right_arm_port=/dev/ttySLRF \
    --robot.id=follower \
    --teleop.type=bi_so100_leader \
    --teleop.left_arm_port=/dev/ttySLLL \
    --teleop.right_arm_port=/dev/ttySLRL \
    --teleop.id=leader


# /dev/ttyACM2 - right leader - 5AB0181062
# /dev/ttyACM3 - right follower - 5AB0179027
# /dev/ttyACM1 - left leader - 5A7A015778
# /dev/ttyACM0 - left follower - 5AAF270447


