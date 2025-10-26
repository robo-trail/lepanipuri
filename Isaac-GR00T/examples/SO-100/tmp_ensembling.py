import torch
import numpy as np

class TimeEnsembler:
    def __init__(self, balancing_factor=0.1, horizon=30, n_joints=16):
        self.balancing_factor = balancing_factor
        self.n_joints = n_joints
        self.temporal_size = int(horizon)
        self.temporal_mask = torch.flip(
            torch.triu(
                torch.ones(self.temporal_size, self.temporal_size, dtype=torch.bool)
            ),
            dims=[1],
        ).numpy()

        self.action_buffer = np.zeros(
            (self.temporal_mask.shape[0], self.temporal_mask.shape[0], self.n_joints)
        )
        self.action_buffer_mask = np.zeros(
            (self.temporal_mask.shape[0], self.temporal_mask.shape[0]), dtype=np.bool_
        )
        # Action chunking with temporal aggregation
        self.temporal_weights = np.array(
            [np.exp(-1 * balancing_factor * i) for i in range(self.temporal_size)]
        )[:, None]

    def ensemble(self, action_chunk):
        # action_chunk:[horizon, n_joints]

        # shift buffer
        self.action_buffer[1:, :, :] = self.action_buffer[:-1, :, :]
        self.action_buffer_mask[1:, :] = self.action_buffer_mask[
            :-1, :
        ]
        self.action_buffer[:, :-1, :] = self.action_buffer[:, 1:, :]
        self.action_buffer_mask[:, :-1] = self.action_buffer_mask[
            :, 1:
        ]
        self.action_buffer_mask = (
            self.action_buffer_mask * self.temporal_mask
        )

        # Add action chunk to action buffer
        self.action_buffer[0] = action_chunk
        self.action_buffer_mask[0] = np.array(
            [True] * self.temporal_mask.shape[0], dtype=np.bool_
        )

        # Ensemble temporally to predict next action
        action = np.sum(
            self.action_buffer[:, 0, :]
            * self.action_buffer_mask[:, 0:1]
            * self.temporal_weights,
            axis=0,
        ) / np.sum(
            self.action_buffer_mask[:, 0:1] * self.temporal_weights
        )

        return action  # (n_joints,)
