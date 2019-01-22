class ReportEntryDecorator < ApplicationDecorator
  delegate_all

  def to_h
    {
      id: id,
      title: title,
      description: description,
      kind: kind,
    }
  end
end
