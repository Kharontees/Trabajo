import pyodbc

from dotenv import load_dotenv
import os

class ConexionBD:

    def __init__(self):
        load_dotenv()
        self.servidor = os.getenv("DB_SERVER")
        self.base_datos = os.getenv("DB_NAME")
        self.usuario = os.getenv("DB_USER")
        self.contrasena = os.getenv("DB_PASSWORD")
        self.conexion = None

    def conectar(self):
        try:
            self.conexion = pyodbc.connect(
                f'DRIVER={{ODBC Driver 17 for SQL Server}};'
                f'SERVER={self.servidor};'
                f'DATABASE={self.base_datos};'
                f'UID={self.usuario};'
                f'PWD={self.contrasena}'
            )
            print("\033[92mConexión exitosa a SQL Server.\033[0m")
        except Exception as e:
            print("\033[31mError al conectar a la base de datos:\033[0m", e)

    def cerrar_conexion(self):
        if self.conexion:
            self.conexion.close()
            print("\033[92mConexión cerrada.\033[0m")

    def ejecutar_consulta(self, consulta, parametros=()):
        try:
            cursor = self.conexion.cursor()
            cursor.execute(consulta, parametros)
            return cursor.fetchall()
        except Exception as e:
            print("Error al ejecutar la consulta:", e)
            return []

    def ejecutar_instruccion(self, consulta, parametros=()):
        try:
            cursor = self.conexion.cursor()
            cursor.execute(consulta, parametros)
            self.conexion.commit()
            print("Instrucción ejecutada correctamente.")
        except Exception as e:
            print("Error al ejecutar la instrucción:", e)
            self.conexion.rollback()


def mostrar_menu():
    print("\n--- MENÚ PRINCIPAL ---")
    print("1. Listar estudiantes")
    print("2. Agregar estudiante")
    print("3. Buscar estudiante por nombre")
    print("4. Eliminar estudiante por ID")
    print("5. Modificar estudiante por ID")
    print("6. Reporte de estudiantes por edad")
    print("7. Salir")

def main():
    db = ConexionBD()
    db.conectar()

    #MAIN LOOP
    while True:
        mostrar_menu()
        opcion = input("Seleccione una opción: ")
    #LISTAR ESTUDIANTE
        if opcion == "1":

            estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes")

            
            print("\n--- Lista de Estudiantes ---")
            for est in estudiantes:
                print(f"id: \033[31m{est[0]}\033[0m, Nombre: \033[92m{est[1]}\033[0m, Edad: {est[2]}")
            print("-----------------------------")
            
    #AGREGAR ESTUDIANTE
        elif opcion == "2":
            try:
                nombre = input("Ingrese el nombre del estudiante: ").strip()

                if not nombre or len(nombre) < 3:# si el nombre no es un string o tiene menos de 3 caracteres
                    print("\033[31mEl nombre no puede estar vacío y debe tener al menos 3 caracteres.\033[0m")
                    continue

                edad = int(input("Ingrese la edad del estudiante: "))# convertimos la edad a entero, esto si no se cumple sale por el value error

                if edad < 15 or edad > 99:
                    print("La edad debe estar entre 15 y 99 años.")
                    continue

                db.ejecutar_instruccion(
                    "INSERT INTO estudiantes (nombre, edad) VALUES (?, ?)",
                    (nombre, edad)
                )
                try:
                    estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes")
                    print("\n--- Lista Actualizada de Estudiantes ---")
                    for est in estudiantes:
                        print(f"id: {est[0]}, Nombre: {est[1]}, Edad: {est[2]}")

                except Exception as e:
                    print("\033[31mError al recuperar la lista de estudiantes:\033[0m", e)
            except ValueError:
                print("\033[31mEdad inválida. Debe ser un número.\033[0m")
    #BUSCAR ESTUDIANTE POR NOMBRE
        elif opcion == "3":
            nombre = input("Ingrese el nombre del estudiante a buscar: ").strip()
            if not nombre:
                print("\033[31mEl nombre no puede estar vacío.\033[0m")
                continue
            try:
                estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes WHERE nombre LIKE ?",(f"%{nombre}%",))
                if estudiantes:
                    print("\n--- Resultados de la Búsqueda ---")
                    for est in estudiantes:
                        print(f"id: {est[0]}, Nombre: {est[1]}, Edad: {est[2]}")
                else:
                    print("\033[31mNo se encontraron estudiantes con ese nombre.\033[0m")
            except Exception as e:
                print("\033[31mError al buscar estudiantes:\033[0m", e)

    #ELIMINAR ESTUDIANTE POR ID
        elif opcion == "4":
            
            estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes")

            
            print("\n--- Lista de Estudiantes ---")
            for est in estudiantes:
                print(f"id: \033[31m{est[0]}\033[0m, Nombre: \033[92m{est[1]}\033[0m, Edad: {est[2]}")
            print("-"*28)
            
            try:
                estudiante_a_eliminar = int(input("Ingrese el ID del estudiante a eliminar: "))

                db.ejecutar_instruccion(
                    "DELETE FROM estudiantes WHERE id = ?",(estudiante_a_eliminar,)) #elimina el estudiante con el id proporcionado
                
                # mostramos la lista actualizada
                estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes")
                print("\n--- Lista Actualizada de Estudiantes ---")

                for est in estudiantes:
                    print(f"id: \033[31m{est[0]}\033[0m, Nombre: \033[92m{est[1]}\033[0m, Edad: {est[2]}")  # Mostramos la lista actualizada
                print("-"*28)
            except ValueError:
                print("\033[31mID inválido. Debe ser un número.\033[0m")
    #MODIFICAR ESTUDIANTE POR ID
        elif opcion == "5":
            try:
                edad = int(input("Ingrese la edad del estudiante: "))
                id = input("Ingrese el ID del estudiante a eliminar: ").strip()
                if not id.isdigit():# si el id no es un dígito
                    print("El ID debe ser un número válido.")
                    continue# salimos del ciclo y volvemos al menú

                if edad < 15 or edad > 99:
                    print("La edad debe estar entre 15 y 99 años.")
                    continue

                db.ejecutar_instruccion(
                    #modificamos la edad del estudiante con set y lo buscamos con id where
                    "UPDATE estudiantes SET edad = ? WHERE id = ?",(edad, id))
                
                #mostramos la lista actualizada con select
                estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes")
                print("\n--- Lista Actualizada de Estudiantes ---")
                for est in estudiantes:
                    print(f"id: {est[0]}, Nombre: {est[1]}, Edad: {est[2]}")
            except ValueError:
                print("Edad inválida. Debe ser un número.")
    #REPORTE DE ESTUDIANTES con edad > 18
        elif opcion == "6":
            try:
                print("\n--- Lista de Estudiantes Totales---")
                estudiantes_totales = db.ejecutar_consulta("SELECT * FROM estudiantes") # se usa db.ejecutar consulta siempre para hacer la sql query
                for est in estudiantes_totales:#se recorre los estudiantes con un for
                    print(f"id: {est[0]}, Nombre: {est[1]}, Edad: {est[2]}") # est[0] es el id, est[1] es el nombre, est[2] es la edad
                print("\n--- Lista de Estudiantes Mayores de 18 Años ---")  

                estudiantes = db.ejecutar_consulta("SELECT * FROM estudiantes WHERE edad > 18")
                for est in estudiantes:
                    print(f"id: {est[0]}, Nombre: {est[1]}, Edad: {est[2]}")
            except Exception as e:
                print("Error al recuperar la lista de estudiantes:", e)#manejo de errores, si falla vuelve al menú
    #SALIR 
        elif opcion == "7":
            print("\nSaliendo...")
            db.cerrar_conexion()
            break
        else:
            print("Opción inválida. Intente de nuevo.")


if __name__ == "__main__":
    main()