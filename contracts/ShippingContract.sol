// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ShippingContract {

  // Status du contrat
  enum ShipStatus {Pending, Shipped, Delivered}
  ShipStatus status;
  
  // Adresse du vendeur
  address public owner;

  // Adresse de l'acheteur
  address public buyer;

  /// Compteur de commande
  uint compteurCommande;
  
  // Structure de l'acheteur
  struct Buyer{
      address addr;
      string name;
      bool init;
  }

  // Structure de la commande
  struct Order{
    string produit;
    uint number;
    uint quantity;
  }

   constructor (address _buyerAddr) payable {
        owner = msg.sender;
        buyer = _buyerAddr;
        status = ShipStatus.Pending;
    }

  function getStatus() public view returns (ShipStatus) {
      return status;
   }

  /// La fonction la transaction a ete effectue
  function delivery(uint invoiceno, uint timestamp) payable public {

    OrderDelivered(buyer, timestamp);

    /// Paiement de la commande au vendeur
    owner.transfer(orders.safepay);

    /// Paiement de la commande
    orders.shipment.courier.transfer(orders.shipment.safepay);
    status = ShipStatus.Delivered;
  }


  ///  Fonction pour envoyer une commande
  function sendOrder(string memory produit, uint quantity) payable public {
    
    /// Accepte les commandes par l'acheteur seulement
    require(msg.sender == buyer);
    
    /// appel l'event
    OrderSent(msg.sender, produit, quantity);
    status = ShipStatus.Shipped;

  }


  /// Map les commandes
  mapping (uint => Order) orders;

  /// Event pour chaque acheteurs enregistré
  event BuyerRegistered(address buyer, string name);




  modifier restricted() {
    require(
      msg.sender == owner,
      "Cette fonction est reservee au proprietaire du contrat"
    );
    _;
  }
   
  /// Event pour chaque nouvelle commande
  event OrderSent(address buyer, string produit, uint quantity);
  //  Event pour dire que ça a ete delivre
  event OrderDelivered(address buyer, uint real_delivey_date);

}
