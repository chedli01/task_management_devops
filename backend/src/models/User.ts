import {
  Table,
  Column,
  Model,
  DataType,
  BeforeCreate,
  HasMany,
  PrimaryKey,
  Default,
} from 'sequelize-typescript';
import bcrypt from 'bcryptjs';
import Task from './Task';

@Table({
  tableName: 'users',
  timestamps: true,
})
export default class User extends Model {
  @PrimaryKey
  @Default(DataType.UUIDV4)
  @Column(DataType.UUID)
  id!: string;

  @Column({
    type: DataType.STRING,
    allowNull: false,
    unique: true,
    validate: {
      len: [3, 50],
    },
  })
  username!: string;

  @Column({
    type: DataType.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  })
  email!: string;

  @Column({
    type: DataType.STRING,
    allowNull: false,
  })
  password!: string;

  @HasMany(() => Task)
  tasks!: Task[];

  @BeforeCreate
  static async hashPassword(user: User) {
    if (user.password) {
      user.password = await bcrypt.hash(user.password, 10);
    }
  }

  async comparePassword(candidatePassword: string): Promise<boolean> {
    return bcrypt.compare(candidatePassword, this.password);
  }

  toJSON() {
    const values = { ...this.get() };
    delete values.password;
    return values;
  }
}