const { mapUsers } = require('../utils');

module.exports = class User {
  static _client;
  static _tableName = 'tasks';

  static async findAll () {
    return this._client.query(`SELECT * FROM ${this._tableName}`);
  }

  static async bulkCreate (tasks) {
    const { rows } = await this._client.query(`
    INSERT INTO "${this._tableName}" (
      "userId",
      "taskText",
      "isDone",
    ) 
    VALUES ${mapUsers(tasks)}
    RETURNING *;`);
    return rows;
  }
};