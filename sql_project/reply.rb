require_relative 'databaser'
require_relative 'user'

class Reply

	# CLASS METHODS

	def self.find_by_id(id)
	  query = <<-SQL
		  SELECT *
			FROM replies
			WHERE replies.id = ?
			SQL

		reply = Databaser.instance.execute(query, id)[0]
		Reply.new(reply)
	end

	def self.find_by_question_id(id)
		query = <<-SQL
			SELECT *
	 		  FROM replies
			 WHERE replies.question_id = ?
			SQL

		replies = Databaser.instance.execute(query, id)

		replies.map {|reply| Reply.new(reply)}
	end




	# INSTANCE METHODS

	def initialize(options = {})
		@question_id = options["question_id"]
		@user_id  = options["user_id"]
		@reply_id = options["reply_id"]
		@body = options["body"]
		@id    = options["id"]
	end


	def author
		query = <<-SQL
		  SELECT *
			  FROM users
			 WHERE users.id = ?
		 SQL

    author = Databaser.instance.execute(query, @user_id)[0]

	  User.new(author)
	end

	def question
		query = <<-SQL
		  SELECT *
			  FROM questions
			 WHERE questions.id = ?
		 SQL

    question = Databaser.instance.execute(query, @question_id)[0]

	  Question.new(question)
	end

	def parent_reply
		query = <<-SQL
		  SELECT *
			  FROM replies
			 WHERE replies.reply_id = ?
		 SQL

    reply = Databaser.instance.execute(query, @reply_id)[0]

	  Reply.new(reply) if reply
	end

	def child_replies
		query = <<-SQL
			SELECT *
			FROM replies
			WHERE replies.reply_id = ?
		SQL

		replies = Databaser.instance.execute(query, @id)

		replies.map {|reply| Reply.new(reply)}
	end


end