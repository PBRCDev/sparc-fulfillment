# Copyright © 2011-2019 MUSC Foundation for Research Development~
# All rights reserved.~

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:~

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.~

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following~
# disclaimer in the documentation and/or other materials provided with the distribution.~

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products~
# derived from this software without specific prior written permission.~

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,~
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT~
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL~
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS~
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR~
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.~

require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "task_confirmation" do
    let(:identity) { create(:identity, email: 'email@test.com') }
    let(:task) { create(:task) }
    let(:mail)  { TaskMailer.task_confirmation(identity, task) }

    #ensure that the subject is correct
    it 'should render the subject' do
      expect(mail.subject).to eq("(SPARCFulfillment) New Task Assigned")
    end

    #ensure that the receiver is correct
    it 'should be to the identity' do
      expect(mail.to).to eq [identity.email]
    end

    #ensure that the sender is correct
    it 'should render the sender email' do
      expect(mail.from).to eq ["from@example.com"]
    end

    #ensure that the e-mail contains a link to the task
    it 'should contain the task link' do
      task_link_path = "tasks_url(id: @task.id)"
      expect(mail.body).to include('/tasks?id')
    end
  end
end