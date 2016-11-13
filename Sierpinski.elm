module Sierpinski exposing (..)

import Graphics.Render as Render
import Color exposing (rgb)
import Random
import Html
import Html.Attributes
import Html.App
import Html exposing (..)
import Debug exposing (..)


main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { diceRolls : DiceRolls }


type alias DiceRolls =
    List (Int)


init : ( Model, Cmd Msg )
init =
    ( { diceRolls = [] }, randomGenerator )


randomGenerator : Cmd (List (Int))
randomGenerator =
    Random.generate identity (Random.list count <| Random.int 1 3)



-- UPDATE


type alias Msg =
    DiceRolls


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | diceRolls = msg }, Cmd.none )



-- VIEW CONSTANTS


size : Float
size =
    400


count : Int
count =
    10000


bottomLeft : Render.Point
bottomLeft =
    ( -size, size )


topCenter : Render.Point
topCenter =
    ( 0, -size )


bottomRight : Render.Point
bottomRight =
    ( size, size )


startPoint : Render.Point
startPoint =
    ( toFloat 0, size / 2 )


dotSize : Float
dotSize =
    2


dotColor : Color.Color
dotColor =
    rgb 80 80 80



-- VIEW


diceRollsToPoints : List (Int) -> Render.Point -> List Render.Point
diceRollsToPoints diceRolls point =
    List.scanl movePoint point diceRolls


movePoint : Int -> Render.Point -> Render.Point
movePoint roll point =
    case roll of
        1 ->
            midpoint point bottomLeft

        2 ->
            midpoint point bottomRight

        3 ->
            midpoint point topCenter

        _ ->
            ( 0, 0 )


midpoint : Render.Point -> Render.Point -> Render.Point
midpoint point1 point2 =
    let
        x =
            (fst point1 + fst point2) / 2

        y =
            (snd point1 + snd point2) / 2
    in
        ( x, y )


circle : Render.Point -> Render.Form msg
circle point =
    Render.circle dotSize |> Render.solidFill dotColor |> Render.position point


view : Model -> Html msg
view model =
    let
        points =
            diceRollsToPoints model.diceRolls startPoint
    in
        points
            |> List.map circle
            |> Render.group
            |> Render.svg (size * 2) (size * 2)
