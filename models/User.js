const { mapUsers } = require('../utils');

module.exports = class User {
  static _client;
  static _tableName = 'users';

  static async findAll () {
    return this._client.query(`SELECT * FROM ${this._tableName}`);
  }

  static async bulkCreate (users) {
    const { rows } = await this._client.query(`
    INSERT INTO "${this._tableName}" (
      "firstName",
      "lastName",
      "email",
      "isMale",
      "birthday",
      "height"
    ) 
    VALUES ${mapUsers(users)}
    RETURNING *;`);
    return rows;
  }
};
