CREATE TABLE CLIENTS (
  [userId] INTEGER PRIMARY KEY NOT NULL,
  [username] TEXT NOT NULL,
  [userPassword] TEXT NOT NULL,
  [roleId] INTEGER NOT NULL,
  [status] TEXT NOT NULL,
  [userLastname] TEXT NOT NULL,
  [telephone] TEXT NOT NULL,
  [userEmail] TEXT NOT NULL
);