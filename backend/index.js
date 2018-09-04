const app = require("express")();
const bodyParser = require("body-parser");

function uuidv4() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
    var r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

var user_id = null;

var orders = [];

let inventory = [
  {
    id: uuidv4(),
    name: "Chocolade brownie",
    description: "Bevat walnoten en soja.",
    amount: 20.0,
    image: "taart1"
  },
  {
    id: uuidv4(),
    name: "Witte chocolade & speculaas",
    description: "Bevat soja. Notenvrije taart.",
    amount: 25.0,
    image: "taart2"
  },
  {
    id: uuidv4(),
    name: "Oreo cheese",
    description: "Bevat soja en rauwe eieren. Notenvrije taart.",
    amount: 22.0,
    image: "taart3"
  },
  {
    id: uuidv4(),
    name: "IJstaart açai",
    description:
      "Vegan taart. Geen soja, gluten, lactose, ei. Natuurlijk gesuikerd (appelsap).",
    amount: 30.0,
    image: "taart4"
  },
  {
    id: uuidv4(),
    name: "Vegan cheesecake",
    description:
      "Vegan taart. Bevat soja, noten (cashew, amandel). Geen gluten, lactose, ei.",
    amount: 23.0,
    image: "taart5"
  },
  {
    id: uuidv4(),
    name: "Vegan snicker cheesecake",
    description:
      "Vegan taart. Bevat soja, noten (pinda, cashew, amandel). Geen gluten, lactose, ei.",
    amount: 24.0,
    image: "taart6"
  },
  {
    id: uuidv4(),
    name: "Tiramisu fruit en speculoos",
    description: "Bevat rauwe eieren. Notenvrij. Geen soja.",
    amount: 16.0,
    image: "taart7"
  },
  {
    id: uuidv4(),
    name: "Julie's Moelleux",
    description:
      "Bevat soja. Bevat noten (amandel). Natuurlijk gesuikerd (rietsuiker).",
    amount: 13.50,
    image: "taart8"
  },
  {
    id: uuidv4(),
    name: "Moelleux met sinaas",
    description:
      "Bevat soja. Bevat noten (amandel). Natuurlijk gesuikerd (rietsuiker).",
    amount: 15.0,
    image: "taart9"
  },
  {
    id: uuidv4(),
    name: "Chocoladetaart",
    description:
      "Bevat soja. Glutenvrij, notenvrij. Natuurlijk gesuikerd (rietsuiker).",
    amount: 15.50,
    image: "taart10"
  },
  {
    id: uuidv4(),
    name: "Julie's summer pie",
    description: "Met fruit van de dag. Bevat soja. Notenvrij.",
    amount: 16.0,
    image: "taart11"
  },
  {
    id: uuidv4(),
    name: "Pavlova slagroom",
    description: "Glutenvrij. Bevat soja. Natuurlijk gesuikerd (rietsuiker).",
    amount: 15.50,
    image: "taart12"
  },
  {
    id: uuidv4(),
    name: "Pavlova chocomouse",
    description:
      "Met fruit van de dag. Glutenvrij, lactose vrij. Bevat soja.",
    amount: 15.50,
    image: "taart13"
  },
  {
    id: uuidv4(),
    name: "Crumble met rabarber",
    description:
      "Geen soja. Bevat noten (hazelnoot, amandel). Natuurlijk gesuikerd (rietsuiker).",
    amount: 13.50,
    image: "taart14"
  },
  {
    id: uuidv4(),
    name: "Suikertaart met appeltjes",
    description:
      "Gemaakt met witte suiker. Lekker warm of koud. Bevat noten (hazelnoot).",
    amount: 13.50,
    image: "taart15"
  },
  {
    id: uuidv4(),
    name: "Witte chocolade speculaas",
    description: "Bevat soja. Geen ei. Notenvrij.",
    amount: 15.50,
    image: "taart16"
  },
  {
    id: uuidv4(),
    name: "Kaastaart fruit & speculaas",
    description: "Geen soja. Geen ei. Notenvrij.",
    amount: 14.50,
    image: "taart17"
  },
  {
    id: uuidv4(),
    name: "Gebakken kaastaart",
    description:
      "Vernieuwd recept: zonder fruit. Geen soja. Notenvrij. Glutenvrij.",
    amount: 14.0,
    image: "taart18"
  },
  {
    id: uuidv4(),
    name: "Citroenkrokant",
    description: "Geen soja. Notenvrij.",
    amount: 14.0,
    image: "taart19"
  },
  {
    id: uuidv4(),
    name: "Pannenkoekentaart",
    description:
      "10 pannenkoeken met crème pâtissière en chocolade. Bevat soja.",
    amount: 25.0,
    image: "taart20"
  }
];

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())


app.get("/orders", (req, res) => res.json(orders));

app.post("/orders", (req, res) => {
  let id = uuidv4();
  user_id = req.body.user_id;
  let cake = inventory.find(item => item["id"] === req.body.cake_id);
  
  if (!cake) {
    return res.json({
      status: false
    });
  }

  orders.unshift({
    id,
    user_id,
    cake,
    status: "In afwachting"
  });
  res.json({
    status: true
  });
});

app.put("/orders/:id", (req, res) => {
  let order = orders.find(order => order["id"] === req.params.id);

  if (!order) {
    return res.json({
      status: false
    });
  }

  orders[orders.indexOf(order)]["status"] = req.body.status;

  return res.json({
    status: true
  });
});

app.get("/inventory", (req, res) => res.json(inventory));


app.delete('/orders/:id', (req, res) => {
  const removeIndex = orders.map(function(order){
    return order.id;
 }).indexOf(req.params.id);
 
 if(removeIndex === -1){
    res.json({message: "Not found"});
 } else {
    orders.splice(removeIndex, 1);
    res.send({message: "Order id " + req.params.id + " removed."});
 }
});

app.get("/", (req, res) =>
  res.json({
    status: "Welkom op de database van Julie's House"
  })
);

app.listen(4000, _ => console.log("App listening on port 4000!"));
