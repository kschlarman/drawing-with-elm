module Main exposing (..)

import Graphics.Render as Render
import Color exposing (rgb)
import Random
import Html
import Html.Attributes
import Html.App
import Html exposing (..)


size : Float
size =
    400


renderShape : List Render.Point -> Render.Form msg
renderShape list =
    Render.polygon list
        |> Render.solidFillWithBorder (rgb 256 256 256) 3 (rgb 0 0 0)


type alias Model =
    { points : List ( Float, Float )
    }


type alias Msg =
    List ( Float, Float )


randomGenerator : Cmd (List ( Float, Float ))
randomGenerator =
    Random.generate identity (Random.list 50 <| Random.pair (Random.float -size size) (Random.float -size size))


main : Program Never
main =
    Html.App.program
        { init = ( { points = [] }, randomGenerator )
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | points = msg }, Cmd.none )


view : Model -> Html Msg
view model =
    renderShape model.points
        |> Render.svg (size * 2) (size * 2)
