import { Sequelize } from 'sequelize-typescript';
import { config } from './env';
import User from '../models/User';
import Task from '../models/Task';

export const sequelize = new Sequelize({
  database: config.database.name,
  username: config.database.username,
  password: config.database.password,
  host: config.database.host,
  port: config.database.port,
  dialect: 'postgres',
  logging: config.nodeEnv === 'development' ? console.log : false,
  models: [User, Task],
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
});

export const connectDatabase = async (): Promise<void> => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connected successfully');

    // if (config.nodeEnv === 'development') {
    await sequelize.sync({ alter: true });
    console.log('✅ Database synchronized');
    // }
  } catch (error) {
    console.error('❌ Unable to connect to database:', error);
    process.exit(1);
  }
};
