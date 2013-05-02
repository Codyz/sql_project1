CREATE TABLE users(

	id INTEGER PRIMARY KEY,

  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(

	id INTEGER PRIMARY KEY,

  title   VARCHAR(255) NOT NULL,
	body    TEXT,
	user_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE q_likes(

	id INTEGER PRIMARY KEY,

	user_id     INTEGER NOT NULL,
	question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id)     REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies(

	id INTEGER PRIMARY KEY,

	question_id INTEGER NOT NULL,
	user_id     INTEGER NOT NULL,
	reply_id    INTEGER,
	body        VARCHAR(255),

	/*Might need foreign key for r_id ??? */
  FOREIGN KEY(question_id) REFERENCES questions(id),
	FOREIGN KEY(user_id)     REFERENCES users(id)
);

CREATE TABLE q_followers(

	id INTEGER PRIMARY KEY,

	question_id INTEGER NOT NULL,
	user_id     INTEGER NOT NULL,

	FOREIGN KEY(user_id)     REFERENCES users(id),
	FOREIGN KEY(question_id) REFERENCES questions(id)
);



/* POPULATE THE TABLE WITH TEST DATA */

INSERT INTO users ('fname', 'lname')
		 VALUES ('Cody', 'Zupnick'),
	 					('Connor', 'Savage');

INSERT INTO questions ('title', 'body', 'user_id')
		 VALUES ('q1', 'codys question', 1),
		 				('q2', NULL, 1),
						('q3', 'connors question', 2);

INSERT INTO q_likes ('user_id', 'question_id')
		 VALUES (1, 3), (1, 2), (2, 2), (2,3), (2,1);

INSERT INTO replies ('question_id', 'user_id', 'reply_id', 'body')
		 VALUES (1, 2, NULL, 'reply1'),
		 				(2, 1, NULL, 'you didnt say anything!'),
						(2, 2, 2, 'maybe he didnt mean to say anything dumbass'),
					  (3, 1, NULL, 'reply3');

INSERT INTO q_followers('question_id', 'user_id')
     VALUES (3,1), (2,1), (1,1), (1,2), (2,2);










