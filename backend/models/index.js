import { Sequelize, DataTypes, Model } from "sequelize";
import config from "../config.js";

const { dialect, database, user, password, host, port } = config.database;
export const sequelize = new Sequelize({
  dialect: dialect,
  database: database,
  username: user,
  password: password,
  host: host,
  port: port,
  ssl: true,
  clientMinMessages: 'notice',
});

export class User extends Model {}

User.init({
  username: { type: DataTypes.STRING },
  email: { type: DataTypes.STRING, unique: true },
  password: { type: DataTypes.STRING }
}, { sequelize });