extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const line_length = 69

# Called when the node enters the scene tree for the first time.
func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "set_scores")
	var error = http_request.request("https://worldtrucker2020.herokuapp.com/top", ["Cache-Control: no-cache"])
	if error != OK:
		push_error("Unable to get top scores")
	pass # Replace with function body.



func set_scores(result, response_code, headers, body):
	if response_code != 200:
		return
	var body_string = body.get_string_from_utf8()
	var response = parse_json(body_string)
	var rank = 0
	for element in response:
		rank += 1
		var time : float = element.conclusionTime
		var username : String = element.username
		var minutes : int = time / 60
		var seconds : int = time - minutes*60
		var cents : int = int(100.0*time)%100
		self.add_item("#%03d %-50s %02d:%02d.%02d" % [rank, username, minutes,seconds,cents])
	pass

