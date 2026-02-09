import jwt, { Secret } from 'jsonwebtoken';
import User from '../models/User';
import { config } from '../config/env';
import { LoginResponse, RegisterResponse } from '../types/index';

class AuthService {
  async register(username: string, email: string, password: string): Promise<RegisterResponse> {
    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      const error: any = new Error('User already exists');
      error.status = 409;
      throw error;
    }

    const user = await User.create({ username, email, password });

    return {
      message: 'User registered successfully',
      user: user.toJSON(),
    };
  }

  async login(email: string, password: string): Promise<LoginResponse> {
    const user = await User.findOne({ where: { email } });

    if (!user || !(await user.comparePassword(password))) {
      const error: any = new Error('Invalid credentials');
      error.status = 401;
      throw error;
    }

    const token = this.generateToken(user.id);

    return {
      message: 'Login successful',
      user: user.toJSON(),
      token,
    };
  }

  private generateToken(userId: string): string {
    
    return jwt.sign({ userId }, config.jwt.secret);
  }
}

export default new AuthService();