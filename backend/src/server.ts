import app from './app';
import { connectDatabase } from './config/databse';
import { connectRedis } from './config/redis';

const startServer = async (): Promise<void> => {
  try {
    await connectDatabase();
    await connectRedis();

    app.listen(3000, () => {
      console.log(`Server running on port 3000`);
      console.log(`Environment: dev`);
    });
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
};

startServer();