require_relative 'databaser'

class Question

	# CLASS METHODS

	def self.find_by_id(id)
	  query = <<-SQL
		  SELECT *
			FROM questions
			WHERE questions.id = ?
			SQL

		question = Databaser.instance.execute(query, id)[0]
		Question.new(question)
	end

	def self.find_by_author_id(id)
		query = <<-SQL
			SELECT *
	 		  FROM questions
			 WHERE questions.user_id = ?
			SQL

		questions = Databaser.instance.execute(query, id)

		questions.map {|question| Question.new(question)}
	end




	# INSTANCE METHODS

	def initialize(options = {})
		@title = options["title"] || ""
		@body  = options["body"]
		@user_id = options["user_id"]
		@id    = options["id"]
	end

	def author
		User.find_by_id(@user_id)
	end

	def replies
		query = <<-SQL
			SELECT *
			FROM replies
			WHERE replies.question_id = ?
		SQL

		replies = Databaser.instance.execute(query, @id)

		replies.map {|reply| Reply.new(reply)}
	end



end
