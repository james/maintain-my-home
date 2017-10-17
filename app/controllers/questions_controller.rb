class QuestionsController < ApplicationController
  def show
    @form = QuestionForm.new
    @question = QuestionSet.new.find(params[:id])
  end

  def submit
    @form = QuestionForm.new(question_form_params)
    @question = QuestionSet.new.find(params[:id])

    return render :show unless @form.valid?

    if @question.multiple_choice?
      return redirect_to @question.redirect_path_for_answer(@form.answer)
    end

    redirect_to @question.redirect_path
  end

  private

  def question_form_params
    params.require(:question_form).permit(:answer)
  end
end
