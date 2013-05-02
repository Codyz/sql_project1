require_relative 'databaser'
require_relative 'user'

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

	def self.most_followed(n)
		QFollower.most_followed_questions(n)
	end

  def self.most_liked(n)
		QuestionLikes.most_liked_questions(n)
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

  def followers
		QFollower.followers_for_question_id(@id)
	end

  def likers
	  QuestionLike.likers_for_question_id(@id)
	end

  def num_likes
	  QuestionLike.num_likes_for_question_id(@id)
	end



end
