import { TaskPriority } from "../enums/task-priority.enum";
import { TaskStatus } from "../enums/task-status.enum";

export interface IUser {
  id: string;
  username: string;
  email: string;
  password: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface ITask {
  id: string;
  title: string;
  description?: string;
  status: TaskStatus;
  priority: TaskPriority;
  dueDate?: Date;
  userId: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface JWTPayload {
  userId: string;
}

export interface LoginResponse {
  message: string;
  user: Omit<IUser, 'password'>;
  token: string;
}

export interface RegisterResponse {
  message: string;
  user: Omit<IUser, 'password'>;
}