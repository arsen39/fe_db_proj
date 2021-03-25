const { Client } = require('pg');
const User = require('./User');
const Phone = require('./Phones');
const Task = require('./Task');
const config = require('../configs/db.json');

const client = new Client(config);

User._client = client;
Phone._client = client;
Task._client = client;

module.exports = {
  client,
  User,
  Phone,
  Task
};
