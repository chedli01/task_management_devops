import { createClient } from 'redis';
import { config } from './env';

const redisClient = createClient({
  url: config.redis.url,
  socket: {
    reconnectStrategy: (retries) => {
      if (retries > 10) {
        console.error('❌ Redis reconnection failed');
        return new Error('Redis reconnection limit exceeded');
      }
      return retries * 100;
    },
  },
});

redisClient.on('error', (err) => console.error('❌ Redis Client Error', err));
redisClient.on('connect', () => console.log('✅ Redis connected'));

export const connectRedis = async (): Promise<void> => {
  try {
    await redisClient.connect();
  } catch (error) {
    console.error('❌ Redis connection failed:', error);
  }
};

export default redisClient;