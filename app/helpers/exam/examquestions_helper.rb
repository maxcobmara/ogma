module Exam::ExamquestionsHelper

  def status_workflow(qstatus)
    flow = Array.new
        if qstatus == nil || qstatus == "New"
          flow << "New" << "Submit"
        elsif qstatus == "Submit" || qstatus == "Editing"
          flow << "Editing" << "Ready For Approval"
        elsif qstatus == "Re-Edit"
          flow << "Re-Edit"  << "For Approval"
        elsif qstatus == "Ready For Approval" || qstatus == "For Approval"
          flow << "Re-Edit" << "Approved" << "Rejected"
        elsif qstatus == "Approved"
           flow << "Approved"
        else
        end
    flow
  end

end
