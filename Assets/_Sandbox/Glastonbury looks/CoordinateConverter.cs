using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class CoordinateConverter
{
    public static float[] CartesianToSpherical(float x, float y, float z, float radius)
    {
        float[] retVal = new float[2];

        if (x == 0)
        {
            x = Mathf.Epsilon;
        }
        retVal[0] = Mathf.Atan(z / x);

        if (x < 0)
        {
            retVal[0] += Mathf.PI;
        }

        retVal[1] = Mathf.Asin(y / radius);

        return retVal;
    }

    public static float[] CartesianToSpherical(Vector3 v, float r)
    {
        return CartesianToSpherical(v.x, v.y, v.z, r);
    }


    public static Vector3 SphericalToCartesian(float latitude, float longitude, float radius)
    {
        float a = radius * Mathf.Cos(longitude);
        float x = a * Mathf.Cos(latitude);
        float y = radius * Mathf.Sin(longitude);
        float z = a * Mathf.Sin(latitude);

        return new Vector3(x, y, z);
    }

}