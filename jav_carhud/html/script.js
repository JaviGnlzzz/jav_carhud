// Todas Las Funciones 

console.log('[(Creador -> TusMuertos.#4903)]')

$(".marchas").fadeOut();
$(".kmnumero").fadeOut();
$(".kmtexto").fadeOut();
$(".contenedoropciones").fadeOut();
$(".barragasolina").fadeOut();
$(".fuel-progress").fadeOut();
$(".fuel-container").fadeOut();
$("#gaso-icon").fadeOut();
$(".porcentaje").fadeOut();

$(function() {

    window.addEventListener('message', function(event) {
        const v = event.data;

        if (v.type === 'cinturon:toggle') {
            if (v.toggle !== null || v.toggle === true && v.checkIsVeh != null || v.checkIsVeh === 1 === true) {
                $('.cinturon').html(`
                    <img src="./img/cinturon.png" id = "cinturon">
                `)
                $('#cinturon').css({'filter' : 'invert(1)'})
            }
            if (v.checkIsVeh) {
                if (v.toggle) {
                    $('.cinturon').html(`
                        <img src="./img/cinturonpuesto.png" id = "cinturon">
                    `)
                } else {
                    $('.cinturon').html(`
                        <img src="./img/cinturon.png" id = "cinturon">
                    `)
                }

                if (v.toggle === true) {val = '0'} else {val = '1'}

                $('#cinturon').css({'filter' : 'invert('+val+')'})
            }
        }
        
        // Luces

        if (v.luces == 1) {
            $('#faro').css({'color' : 'white', 'text-shadow' : '0 0 0 white'})
        };
        
        if (v.luceslargas == 1) {
            $('#faro').css({'color' : 'white', 'text-shadow' : '0 0 .4vw white'})
        };
        
        if (v.luces == 0 && v.luceslargas == 0) {
            $('#faro').css({'color' : '#928b94', 'text-shadow' : '0 0 0 white'})
        }

        // Cerrar Coche
         
        if (v.locked == 1){
            $('#bloqueo').css({'color' : 'rgb(0, 235, 74)'});
        }else if (v.locked == 2){
            $('#bloqueo').css({'color' : 'rgb(235, 0, 51)'});
        }

        // Daño

        if (v.damage <= 900){
            $('#daño').css({'color' : 'rgb(235, 0, 51)'});
        }else if (v.damage > 900){
            $('#daño').css({'color' : '#928b94'});
        }

        // Todo Coche

        if (v.type === 'carhud:update') {
            if (v.isInVehicle) {
                $(".contenedoropciones").fadeIn();
                $(".marchas").fadeIn();
                $(".marchas").html(Math.round(v.gear) + "");
                $(".kmnumero").fadeIn();
                $(".kmtexto").fadeIn();
                $(".kmnumero").html(('000' + Math.round(v.speed)).substr(-3));
                $(".barragasolina").fadeIn();
                $("#gaso-icon").fadeIn();
                $(".fuel-container").fadeIn();
                $(".fuel-progress").fadeIn();
                $(".porcentaje").fadeIn();
                $(".fuel-progress").css("width", Math.round(v.fuel) + "%");
                $(".porcentaje").html(Math.round(v.fuel) + "/100");
                $(".porcentaje").html(Math.round(v.fuel) + "/100");

            } else {
                $(".contenedoropciones").fadeOut();
                $(".marchas").fadeOut();
                $(".kmnumero").fadeOut();
                $(".kmtexto").fadeOut();
                $(".fuel-progress").fadeOut();
                $(".fuel-container").fadeOut();
                $("#gaso-icon").fadeOut();
                $(".porcentaje").fadeOut();
            }

            if (Math.round(v.speed) === 0) {
                $(".kmnumero").html("000");
            }
        }
    });
});