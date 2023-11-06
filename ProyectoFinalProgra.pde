import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

import processing.core.PApplet;

int numItems = 10;  // Total de elementos en la base de datos
int itemsPerPage = 5;  // Número de elementos por página
int currentPage = 1;  // Página actual
float scrollPosition = 1;  // Posición vertical del scroll

PApplet parent; // Declaración de la variable para acceder a las funciones de Processing

PImage img;

String currentWindow = "mainMenu";

// Variable de botón de menú principal
boolean backButtonPressed = false;

Connection dbConnection;
String url = "jdbc:mysql://localhost:3306/inventario";
String user = "root";
String dbPassword = "root";

void setup() {
  size(1600, 1000);
  img = loadImage("ecoarte.png");
img.resize(1600, 1000);
parent = this; // Asigna la instancia actual de Processing a la variable parent

 try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    dbConnection = DriverManager.getConnection(url, user, dbPassword);
    System.out.println("Conexión a la base de datos exitosa.");
} catch (ClassNotFoundException e) {
    System.err.println("Error al cargar el controlador JDBC: " + e.getMessage());
} catch (SQLException e) {
    System.err.println("Error al conectar a la base de datos: " + e.getMessage());
  }
}


void draw() {
  background(255);

drawBackButton();

  if (backButtonPressed) {
    // Regresar al menú principal
    currentWindow = "mainMenu";
    backButtonPressed = false; // Restablecer el estado del botón
  }

if (currentWindow.equals("mainMenu")) {
    drawMainMenu();
  } else if (currentWindow.equals("inventoryManagement")) {
    drawInventoryManagement();
  } else if (currentWindow.equals("productionControl")) {
    drawProductionControl();
  } else if (currentWindow.equals("orderRegistration")) {
    drawOrderRegistration();
  } else if (currentWindow.equals("reportGeneration")) {
    drawReportGeneration();
  }
}

void drawMenuButton(String label, float x, float y) {
  fill(#5BE0ED);
  rect(x, y, 400, 40);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(label, x + 200, y + 20);
}

void drawMainMenu() {
  image(img, 0,0);
    fill(0);
  textSize(30);
  textAlign(CENTER);

  // Botones del menú
  drawMenuButton("Gestión de Inventario", 600, 450);
  drawMenuButton("Datos de compras y ventas", 600, 500);
  drawMenuButton("Registro de Pedidos", 600, 550);
  drawMenuButton("Sucursales", 600, 600);
}


void drawInventoryManagement() {
  background(255);
  image(img, 0, 0);
  textSize(22);

  // Consulta y muestra datos de la tabla en la base de datos
  if (dbConnection != null) {
    try {
      Statement statement = dbConnection.createStatement();
      String query = "SELECT * FROM producto ORDER BY idproducto"; // Ordenar por ID
      ResultSet resultSet = statement.executeQuery(query);

      int count = 0; // Contador de elementos en la página actual
      int currentPage = 0; // Página actual
      float scrollPosition = 0; // Posición vertical del scroll
      float scrollSpeed = 20; // Velocidad de desplazamiento del scroll

      while (resultSet.next()) {
        if (count >= currentPage * itemsPerPage && count < (currentPage + 1) * itemsPerPage) {
          float y = 150 + (count - currentPage * itemsPerPage) * 100 - scrollPosition; // Calcula la posición vertical ajustada por el scroll
          float x = 200;

          String id = resultSet.getString("idproducto");
          String Producto = resultSet.getString("Producto");
          String descripcion = resultSet.getString("Descripcion");
          String stock = resultSet.getString("Stock_inicial");
          String precio = resultSet.getString("Precio");
          String lugar = resultSet.getString("Lugar_origen");
          String fecha = resultSet.getString("Fecha_registro");

          // Mostrar los datos en la página actual
          text("ID: " + id, x, y);
          text("Producto: " + Producto, x+170, y);
          text("Descripción: " + descripcion, x+400, y);
          text("Stock: " + stock, x, y+30);
          text("Precio: " + precio, x+170, y+30);
          text("Lugar de origen: " + lugar, x+400, y+30);
          text("Fecha: " + fecha, x, y+55);
        }

        count++;
      }
      numItems = count;  // Actualiza el número total de elementos

      statement.close();

      // Detección de eventos de scroll
      float scrollDelta = parent.mouseY - parent.pmouseY;
      if (scrollDelta != 0) {
        scrollPosition += scrollDelta * scrollSpeed;
       
      }
        // Actualiza la página actual en función de la posición del scroll
  currentPage = floor(scrollPosition / 50);
    } catch (SQLException e) {
      System.err.println("Error al ejecutar la consulta: " + e.getMessage());
    }
    drawBackButton();
  }
}

void drawProductionControl() {
background(255);
  image(img, 0, 0);

  fill(#5BE0ED);
  rect(150, 150, 150, 40);

  textSize(22);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Ventas", 225, 170); // Texto en el botón

  if (dbConnection != null) {
    try {
      Statement statement = dbConnection.createStatement();
      String query = "SELECT * FROM ventas ORDER BY id";
      ResultSet resultSet = statement.executeQuery(query);

      int count = 0;
      int currentPage = 0;
      float scrollPosition = 0;
      float scrollSpeed = 20;

      while (resultSet.next()) {
        if (count >= currentPage * itemsPerPage && count < (currentPage + 1) * itemsPerPage) {
          float y = 200 + (count - currentPage * itemsPerPage) * 175 - scrollPosition;
          float x = 225;

          String id = resultSet.getString("id");
          String Producto = resultSet.getString("Producto");
          String descripcion = resultSet.getString("Descripcion");
          String id_sucursal = resultSet.getString("id_Sucursal");
          String Fecha_venta = resultSet.getString("Fecha_venta");
          String Cantidad = resultSet.getString("Cantidad");

          text("ID: " + id, x, y);
          text("Producto: " + Producto, x, y + 25);
          text("Descripción: " + descripcion, x, y + 50);
          text("ID Sucursal: " + id_sucursal, x, y + 75);
          text("Fecha de Venta: " + Fecha_venta, x, y + 100);
          text("Cantidad: " + Cantidad, x, y + 125);
        }
        count++;
      }
      statement.close();

      float scrollDelta = mouseY - pmouseY;
      if (scrollDelta != 0) {
        scrollPosition += scrollDelta * scrollSpeed;
      }

      currentPage = floor(scrollPosition / 300);
    } catch (SQLException e) {
      System.err.println("Error al ejecutar la consulta: " + e.getMessage());
    }
  }
  fill(#5BE0ED);
    rect(1000,150,150,40);
  textSize(22);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Compras", 1075, 170); // Texto en el botón
  
  
  if (dbConnection != null) {
    try {
        Statement statement = dbConnection.createStatement();
        String query = "SELECT * FROM compras ORDER BY idCompras";
        ResultSet resultSet = statement.executeQuery(query);

        int count = 0;
        int currentPage = 0;
        float scrollPosition = 0;
        float scrollSpeed = 20;

        while (resultSet.next()) {
            if (count >= currentPage * itemsPerPage && count < (currentPage + 1) * itemsPerPage) {
                float y = 200 + (count - currentPage * itemsPerPage) * 150 - scrollPosition;
                float x = 1075;

                String idCompras = resultSet.getString("idCompras");
                String Fecha_compra = resultSet.getString("Fecha_compra");
                String idproducto = resultSet.getString("idproducto");
                String Descripcion = resultSet.getString("Descripcion");
                String Cantidad = resultSet.getString("Cantidad");

                text("ID: " + idCompras, x, y);
                text("Descripción: " + Fecha_compra, x, y + 25);
                text("Stock: " + idproducto, x, y + 50);
                text("Producto: " + Descripcion, x, y + 75);
                text("Precio: " + Cantidad, x, y + 100);
            }
            count++;
        }

        statement.close();

        float scrollDelta = mouseY - pmouseY;
        if (scrollDelta != 0) {
            scrollPosition += scrollDelta * scrollSpeed;
        }

        currentPage = floor(scrollPosition / 300);
    } catch (SQLException e) {
        System.err.println("Error al ejecutar la consulta: " + e.getMessage());
    }
    drawBackButton();
}
}
void drawOrderRegistration() {
  background(255);
  image(img, 0,0);
  textSize(22);

if (dbConnection != null) {
    try {
      Statement statement = dbConnection.createStatement();
      String query = "SELECT * FROM pedidos ORDER BY idpedidos"; // Reemplaza "tu_tabla" por el nombre de tu tabla
      ResultSet resultSet = statement.executeQuery(query);
      
      int count = 0;
        int currentPage = 0;
        float scrollPosition = 0;
        float scrollSpeed = 20;

      while (resultSet.next()) {
        if (count >= currentPage * itemsPerPage && count < (currentPage + 1) * itemsPerPage) {
                float y = 150 + (count - currentPage * itemsPerPage) * 120 - scrollPosition;
                float x = 200;
                
        String idpedidos = resultSet.getString("idpedidos"); // Reemplaza "id" por el nombre de la columna que deseas obtener
        String Producto = resultSet.getString("Producto"); // Reemplaza "nombre" por el nombre de la columna que deseas obtener
        String descripcion = resultSet.getString("Descripcion");
        String Estado = resultSet.getString("Estado");
        
        text("ID del pedido: " + idpedidos, x, y+25);    
        text("Producto: " + Producto, x, y+50); 
        text("Descripción: " + descripcion , x, y+75);
        text("Estado: " + Estado, x, y+100);
      }
       count++;
        }

        statement.close();

        float scrollDelta = mouseY - pmouseY;
        if (scrollDelta != 0) {
            scrollPosition += scrollDelta * scrollSpeed;
        }

        currentPage = floor(scrollPosition / 300);
    } catch (SQLException e) {
        System.err.println("Error al ejecutar la consulta: " + e.getMessage());
    }
    drawBackButton();
}}

void drawReportGeneration() {
  image(img, 0,0);
  textSize(22);
  
if (dbConnection != null) {
    try {
      Statement statement = dbConnection.createStatement();
      String query = "SELECT * FROM sucursal ORDER BY id_Sucursal"; // Reemplaza "tu_tabla" por el nombre de tu tabla
      ResultSet resultSet = statement.executeQuery(query);
      
         int count = 0;
        int currentPage = 0;
        float scrollPosition = 0;
        float scrollSpeed = 20;

      while (resultSet.next()) {
        if (count >= currentPage * itemsPerPage && count < (currentPage + 1) * itemsPerPage) {
                float y = 150 + (count - currentPage * itemsPerPage) * 100 - scrollPosition;
                float x = 400;
                
        String id_Sucursal = resultSet.getString("id_Sucursal"); // Reemplaza "id" por el nombre de la columna que deseas obtener
        String Nombre_sucursal = resultSet.getString("Nombre_sucursal"); // Reemplaza "nombre" por el nombre de la columna que deseas obtener
        String Telefono = resultSet.getString("Telefono");
        
        text("ID de la sucursal: " + id_Sucursal, x, y+25);    
        text("Nombre de la sucursal: " + Nombre_sucursal,x, y+50); 
        text("Telefono: " + Telefono , x, y+75);
      }
       count++;
        }

        statement.close();

        float scrollDelta = mouseY - pmouseY;
        if (scrollDelta != 0) {
            scrollPosition += scrollDelta * scrollSpeed;
        }

        currentPage = floor(scrollPosition / 300);
    } catch (SQLException e) {
        System.err.println("Error al ejecutar la consulta: " + e.getMessage());
    }
    drawBackButton();
}

  // Botón para regresar al menú principal
  drawBackButton();
}

void mouseClicked() {
   if (currentWindow.equals("login")) {
    // Lógica para la pantalla de inicio de sesión
  } else if (currentWindow.equals("mainMenu")) {
    if (mouseX >= 300 && mouseX <= 900) {
      if (mouseY >= 450 && mouseY <= 490) {
        currentWindow = "inventoryManagement";
      } else if (mouseY >= 500 && mouseY <= 540) {
        currentWindow = "productionControl";
      } else if (mouseY >= 550 && mouseY <= 590) {
        currentWindow = "orderRegistration";
      } else if (mouseY >= 600 && mouseY <= 630) {
        currentWindow = "reportGeneration";
      }
    }
  } else if (currentWindow.equals("inventoryManagement")) {
    
    }
   else if (currentWindow.equals("productionControl")) {
    // Lógica para la pantalla de control de producción
  } else if (currentWindow.equals("orderRegistration")) {
    // Lógica para la pantalla de registro de pedidos
  } else if (currentWindow.equals("reportGeneration")) {
    // Lógica para la pantalla de generación de informes
  }
  if (currentWindow.equals("productionControl")) {
    
  }
  if (currentWindow.equals("orderRegistration")) {
  }
}


void mousePressed() {
  if (currentWindow.equals("login")) {
    if (mouseX >= 300 && mouseX <= 500 && mouseY >= 135 && mouseY <= 165) {
      // Clic en el campo de usuario
    } else if (mouseX >= 300 && mouseX <= 500 && mouseY >= 185 && mouseY <= 215) {
      // Clic en el campo de contraseña
    }
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    try {
      if (dbConnection != null) {
        dbConnection.close();
        println("Conexión cerrada.");
      }
    } catch (SQLException e) {
      println("Error al cerrar la conexión: " + e.getMessage());
    }
    exit();
  }
}

void drawBackButton() {
  fill(100); // Color del botón
  rect(1480, 900, 100, 40); // Posición y tamaño del botón
  fill(255); // Color del texto
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Volver", 1530, 920); // Texto en el botón
  surface.setAlwaysOnTop(true);

  // Verificar si se hizo clic en el botón
  if (mouseX >= 1480 && mouseX <= 1600 && mouseY >= 900 && mouseY <= 940) {
    if (mousePressed) {
      backButtonPressed = true;
    }
  }
}


void logout() {
}

void setupDatabaseConnection() {
  // Configura la conexión a la base de datos MySQL.
}

void closeDatabaseConnection() {
  // Cierra la conexión a la base de datos MySQL al salir de la aplicación.
}
