require_relative 'user'

class QuestionLikes

	def self.likers_for_question_id(id)
		query = <<-SQL
			SELECT users.*
			  FROM q_likes
				JOIN users ON q_likes.user_id = users.id
			 WHERE q_likes.question_id = ?
			SQL

			likers = Databaser.instance.execute(query, id)

			likers.map {|liker| User.new(liker)}
	end

	def self.num_likes_for_question_id(id)
		query = <<-SQL
			SELECT COUNT(q_likes.user_id)
			  FROM q_likes
			 WHERE q_likes.question_id = ?
			SQL

			Databaser.instance.execute(query, id)[0]
	end

	def self.liked_questions_for_user_id(id)
		query = <<-SQL
			SELECT questions.*
			  FROM q_likes
				JOIN questions ON questions.id = q_likes.question_id
			 WHERE q_likes.user_id = ?
			SQL

			questions = Database.instance.execute(query, id)

			questions.map {|question| Question.new(question)}
	end

  def self.most_liked_questions(n)
	  query = <<-SQL
		  SELECT questions.*
			  FROM questions
				JOIN q_likes ON questions.id = q_likes.question_id
		GROUP BY q_likes.question_id
	  ORDER BY COUNT(q_likes.user_id)
		SQL

		questions = Databaser.instance.execute(query)

		questions[0..n].map { |question| Question.new(question) }
	end



