# Description
#   Remedy Ticket Info
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <TICKET ID> - INC, CRQ, TAS, OP, RESTR, CHNGE

# Notes:
#   None
#
# Author:
#   KeShiXiong <sxke@Ctrip.com>

class Ticket
  constructor:(@tid) ->
    @requestBody = ""
    @data = undefined

  fetchInfo:(robot, callback) ->
    self = @
    robot.logger.info('start fetchInfo')
    robot.http('http://osg.ops.ctripcorp.com/api/11100').post(JSON.stringify({
      "access_token": "a22335403b2e5bb676efe821a9474993",
      "request_body": @requestBody
    })) (err, res, body) ->
      robot.logger.debug('fetchInfo body', body)

      try
        jsonBody = JSON.parse(body)
      catch
        jsonBody = {}

      if jsonBody?.status == 'success'
        self.data = jsonBody.data[0] if jsonBody.data?.length > 0
      else
        robot.logger.error('fetchInfo fail', jsonBody)

      callback err, body

  getInfoStr: ->
    'http://r.ctripcorp.com/remedy/'+@tid


class IncidentTicket extends Ticket

  statusMap: {
    0: "已记录",
    1: "已分派",
    2: "处理中",
    3: "暂停中",
    4: "已解决",
    5: "已关闭",
    6: "已取消",
    7: "已重开"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "HPD:Help Desk",
      "query": {
        "Incident_Number": @tid
      },
      "fieldNames": [
        "Assigned_Group",
        "Assignee",
        "Description",
        "Status"
      ],
      "order": "Entry_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  处理人: #{@data.Assignee}  主题: #{@data.Description}  [color=#0000FF]#{@statusMap[@data.Status]}[/color]"
    str

class InfrastructureChangeTicket extends Ticket
  statusMap: {
    0: "起草中",
    1: "已提交",
    2: "已设计",
    3: "已接受",
    4: "已批准",
    5: "进行中",
    6: "已实施",
    7: "已复核",
    8: "暂停中",
    9: "已延期",
    10: "已否决",
    11: "已完成",
    12: "已失败"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "CHG:Infrastructure Change",
      "query": {
        "Infrastructure_Change_ID": @tid
      },
      "fieldNames": [
        "ASGRP",
        "ASCHG",
        "Description",
        "Change_Request_Status"
      ],
      "order": "Request_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  负责人: #{@data.ASCHG}  主题: #{@data.Description}  [color=#0000FF]#{@statusMap[@data.Change_Request_Status]}[/color]"
    str

class TaskTicket extends Ticket
  statusMap: {
    0: "等待中",
    1: "已分派",
    2: "已接受",
    3: "进行中",
    4: "已完成",
    5: "已失败",
    6: "已取消",
    7: "已拒绝"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "TMS:Task",
      "query": {
        "Task_ID": @tid
      },
      "fieldNames": [
        "Assignee_Group",
        "Assignee",
        "TaskName",
        "TMS_Status"
      ],
      "order": "Task_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  工单负责人: #{@data.Assignee}  主题: #{@data.TaskName}  [color=#0000FF]#{@statusMap[@data.TMS_Status]}[/color]"
    str

class OPTTicket extends Ticket
  statusMap: {
    0: "新操作任务",
    1: "任务实施中",
    2: "任务完成"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "CTRIP:OperationWorkOrder",
      "query": {
        "Request_ID": @tid
      },
      "fieldNames": [
        "OPT_Assigned_Group",
        "OPT_Assigned",
        "Short_Description",
        "Status"
      ],
      "order": "Request_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  负责人: #{@data.OPT_Assigned}  主题: #{@data.Short_Description}  [color=#0000FF]#{@statusMap[@data.Status]}[/color]"
    str

class RestorationTicket extends Ticket
  statusMap: {
    8000: "处理中",
    25000: "已恢复",
    32000: "已关闭",
    33000: "已取消"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "CTRIP:RestorationTicket",
      "query": {
        "Ticket_ID": @tid
      },
      "fieldNames": [
        "Chr_AssignedGroup",
        "Chr_Assignee",
        "Summary",
        "Status"
      ],
      "order": "Request_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  负责人: #{@data.Chr_Assignee}  主题: #{@data.Summary}  [color=#0000FF]#{@statusMap[@data.Status]}[/color]"
    str

class ChangeRequestTicket extends Ticket
  statusMap: {
    0: "准备中",
    1: "待审批",
    2: "已批准",
    3: "待执行",
    4: "执行中",
    5: "已过期",
    6: "已拒绝",
    7: "已完成",
    8: "已取消",
    9: "已关闭",
    10: "已失败",
    11: "已接受"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "CTRIP:ChangeRequest",
      "query": {
        "TicketID": @tid
      },
      "fieldNames": [
        "Assigned_Group_",
        "Assignee",
        "Summary",
        "Status"
      ],
      "order": "Request_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "  处理人: #{@data.Assignee}  主题: #{@data.Summary}  [color=#0000FF]#{@statusMap[@data.Status]}[/color]"
    str

class ServiceRequestTicket extends Ticket
  statusMap: {
    0: "Pending",
    1: "Success",
    2: "Failure",
    3: "Processing",
    4: "Hold"
  }
  statusMap2: {
    0: "ENP",
    1: "WOLF"
  }

  constructor:(@tid) ->
    super @tid
    @requestBody = {
      "action": "CTRIP:APIStagingForm",
      "query": {
        "ApplicationID": @tid
      },
      "fieldNames": [
        "Chr_LastENPEventID",
        "Chr_CallbackURL",
        "Status",
        "MQ_Type",
        "OParameter1",
        "Remedy_Event"
      ],
      "order": "Transaction_ID",
      "start": 0,
      "limit": 1
    }

  getInfoStr: ->
    str = super
    if @data
      str += "\nRemedy_Event: #{@data.Remedy_Event}\nMQ类型: #{@statusMap2[@data.MQ_Type]}\nENP事件ID: #{@data.Chr_LastENPEventID}\n回调地址: #{@data.Chr_CallbackURL}\nStatus: [color=#0000FF]#{@statusMap[@data.Status]}[/color]\n数据: #{@data.OParameter1}"
    str

module.exports = (robot) ->
  robot.hear /^ *(?:INC|CRQ|TAS)\d{12} *$|^ *(?:RESTR|CHNGE|APPSV|SASRV|SECUR|MONTR|DBSRV)\d{10} *$|^ *OP\d{13} *$/i, (res) ->
    robot.logger.info('matched ticket bot', res.match)
    match = res.match[0].trim()
    if match.indexOf('INC') == 0
      tickObj = new IncidentTicket(match)
    else if match.indexOf('CRQ') == 0
      tickObj = new InfrastructureChangeTicket(match)
    else if match.indexOf('TAS') == 0
      tickObj = new TaskTicket(match)
    else if match.indexOf('OP') == 0
      tickObj = new OPTTicket(match)
    else if match.indexOf('RESTR') == 0
      tickObj = new RestorationTicket(match)
    else if match.indexOf('CHNGE') == 0
      tickObj = new ChangeRequestTicket(match)
    else
      tickObj = new ServiceRequestTicket(match)

    tickObj?.fetchInfo robot, (err, data) ->
      robot.logger.error err if err
      res.send tickObj.getInfoStr()
