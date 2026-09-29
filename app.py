from flask import Flask, render_template, jsonify
from database import obtener_conexion

app = Flask(__name__)

@app.route("/")
def inicio():
    return "Plataforma de adopción de mascotas"

@app.route("/mascotas")
def mascotas():
    conexion = obtener_conexion()

    if conexion is None:
        return {"error": "No se pudo conectar a la base de datos"}, 500

    cursor = conexion.cursor(dictionary=True)
    cursor.execute("SELECT * FROM mascotas")
    resultados = cursor.fetchall()

    cursor.close()
    conexion.close()

    return render_template("mascotas.html", mascotas=resultados)


@app.route("/api/mascotas", methods=["GET"])
def listar_mascotas():
    conexion = obtener_conexion()

    if conexion is None:
        return jsonify({
            "error": "No se pudo conectar a la base de datos"
        }), 500

    cursor = None

    try:
        cursor = conexion.cursor(dictionary=True)

        cursor.execute("""
            SELECT *
            FROM mascotas
        """)
        mascotas = cursor.fetchall()
        return jsonify(mascotas), 200
    except Exception as error:
        print(f"Error al consultar las mascotas: {error}")
        return jsonify({
            "error": "Error al consultar las mascotas"
        }), 500
    finally:
        if cursor is not None:
            cursor.close()

        conexion.close()

@app.route("/api/mascotas/<int:id_mascota>", methods=["GET"])
def obtener_mascota(id_mascota):
    conexion = obtener_conexion()

    if conexion is None:
        return jsonify({
            "error": "No se pudo conectar a la base de datos"
        }), 500
    cursor = None

    try:
        cursor = conexion.cursor(dictionary=True)

        cursor.execute("""
            SELECT *
            FROM mascotas
            WHERE id_mascota = %s
        """, (id_mascota,))
        mascota = cursor.fetchone()

        if mascota is None:
            return jsonify({
                "error": "Mascota no encontrada"
            }), 404
        return jsonify(mascota), 200

    except Exception as error:
        print(f"Error al consultar la mascota: {error}")
        return jsonify({
            "error": "Error al consultar la mascota"
        }), 500

    finally:
        if cursor is not None:
            cursor.close()
        conexion.close()

if __name__ == "__main__":
    app.run(debug=True)