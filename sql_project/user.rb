require_relative 'databaser'
require_relative 'question'
require_relative 'reply'
require_relative 'q_follower'
require_relative 'q_like'

class User

	def self.find_by_id(id)
	  query = <<-SQL
		  SELECT *
			FROM users
			WHERE users.id = ?
			SQL

		user = Databaser.instance.execute(query, id)[0]
		User.new(user)
	end

	def self.find_by_name(fname, lname)
		query = <<-SQL
			SELECT *
	 		  FROM users
			 WHERE users.fname = ? AND users.lname = ?
			SQL

		users = Databaser.instance.execute(query, fname, lname)

		users.map {|user| User.new(user)}
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

		questions = Databaser.instance.execute(query, @id)

		questions.map {|question| Question.new(question) }
	end

  def authored_replies
		query = <<-SQL
		  SELECT *
			  FROM replies
			 WHERE user_id = ?
		  SQL

	  replies = Databaser.instance.execute(query, @id)

		replies.map { |reply| Reply.new(reply) }
	end

  def followed_questions
    QFollower.followed_questions_for_user_id(@id)
	end


end