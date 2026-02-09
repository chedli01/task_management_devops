export type User= {
  id: string;
  username: string;
  email: string;
}

export type Task ={
  id: string;
  title: string;
  description?: string;
  status: 'pending' | 'in_progress' | 'completed';
  priority: 'low' | 'medium' | 'high';
  dueDate?: string;
  userId: string;
  createdAt: string;
  updatedAt: string;
}

export type LoginResponse= {
  message: string;
  user: User;
  token: string;
}

export type RegisterResponse= {
  message: string;
  user: User;
}

export type ApiError= {
  error: string;
  details?: string[];
}