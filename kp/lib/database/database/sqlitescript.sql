CREATE TABLE IF NOT EXISTS CLIENTS (
  USERID INTEGER PRIMARY KEY AUTOINCREMENT,
  USEREMAIL TEXT NOT NULL,
  USERPASSWORD TEXT NOT NULL,
  USERNAME TEXT NOT NULL,
  USERLASTNAME TEXT NOT NULL,
  TELEPHONE TEXT NOT NULL,
  USERROLEID INTEGER NOT NULL,
  USERSTATUS TEXT NOT NULL
);

INSERT INTO CLIENTS (
  USEREMAIL,
  USERPASSWORD,
  USERNAME,
  USERLASTNAME,
  TELEPHONE,
  USERROLEID,
  USERSTATUS
) VALUES (
  'john@example.com',
  'password123',
  'John',
  'Doe',
  '1234567890',
  1,
  'Active'
);

INSERT INTO Clients (
  USEREMAIL,
  USERPASSWORD,
  USERNAME,
  USERLASTNAME,
  TELEPHONE,
  USERROLEID,
  USERSTATUS
) VALUES (
  'jane@example.com',
  'password456',
  'Jane',
  'Smith',
  '9876543210',
  2,
  'Inactive'
);