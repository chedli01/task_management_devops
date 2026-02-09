import app from './app';
import { connectDatabase } from './config/databse';
import { config } from './config/env';
import { connectRedis } from './config/redis';

const startServer = async (): Promise<void> => {
  try {
    await connectDatabase();
    await connectRedis();

    app.listen(config.port, () => {
      console.log(`Server running on port ${config.port}`);
      console.log(`Environment: dev`);
    });
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
};

startServer();