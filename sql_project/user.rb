require_relative 'databaser'
require_relative 'question'
require_relative 'reply'
require_relative 'q_follower'
require_relative 'q_like'

class User

  attr_reader :id, :fname, :lname

	def self.find_by_id(id)
	  query = <<-SQL
		  SELECT *
			FROM users
			WHERE users.id = ?
			SQL

		users = Databaser.instance.execute(query, id)
		users.map { |user| User.new(user) }.first
	end

	def self.find_by_name(fname, lname)
		query = <<-SQL
			SELECT *
	 		  FROM users
			 WHERE users.fname = ? AND users.lname = ?
			SQL

		users = Databaser.instance.execute(query, fname, lname)

		users.map {|user| User.new(user)}.first
	end

  def self.user_ids
		query = <<-SQL
		  SELECT users.id
			  FROM users
			SQL

		Databaser.instance.execute(query).map { |id_hash| id_hash.values.first}
	end

	# INSTANCE METHODS

	def initialize(options = {})
		@fname = options["fname"] || ""
		@lname = options["lname"] || ""
		@id    = options["id"]
	end


  def authored_questions
		query = <<-SQL
		  SELECT *
			  FROM questions
			 WHERE user_id = ?
		  SQL

		questions = Databaser.instance.execute(query, id)

		questions.map {|question| Question.new(question) }
	end

  def authored_replies
		query = <<-SQL
		  SELECT *
			  FROM replies
			 WHERE user_id = ?
		  SQL

	  replies = Databaser.instance.execute(query, id)

		replies.map { |reply| Reply.new(reply) }
	end

  def followed_questions
    QFollower.followed_questions_for_user_id(id)
	end

	def liked_questions
		QuestionLike.liked_questions_for_user_id(id)
	end

  def average_karma
    query = <<-SQL
		  SELECT CAST((COUNT(q_likes.user_id)) AS REAL) /COUNT(DISTINCT(questions.id))
			  FROM questions
        LEFT OUTER JOIN q_likes
				  ON q_likes.question_id = questions.id
			 WHERE questions.user_id = ?
			SQL

		Databaser.instance.execute(query, id).first
	end

	def save
	  if User.user_ids.include?(id)
		  self.update
		else
			self.insert
		end
	end

	def insert
		insert = <<-SQL
		  INSERT INTO users ('id', 'fname', 'lname')
			     VALUES (:id, :fname, :lname)
			SQL

		opts = {'id' => id, 'fname' => fname, 'lname' => lname}
		Databaser.instance.execute(insert, opts)
		nil
	end

	def update
		update = <<-SQL
			UPDATE users
			   SET fname = :fname, lname = :lname
			 WHERE users.id = :id
			SQL

			opts = {'id' => id, 'fname' => fname, 'lname' => lname}
			Databaser.instance.execute(update, opts)
			nil
	end


end