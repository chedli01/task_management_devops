import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: process.env.PORT || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  
  database: {
    name:process.env.DB_NAME || '',
    username:process.env.DB_USERNAME || '',
    password:process.env.DB_PASSWORD || '',
    host:process.env.DB_HOST || 'localhost',
    port:process.env.DB_PORT ? Number(process.env.DB_PORT) : 5432,
  },
  
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  
  jwt: {
    secret: process.env.JWT_SECRET as string || 'dev-secret-change-in-production',
    expiresIn: '7d',
  },
  
  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  },
};